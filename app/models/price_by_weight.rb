class PriceByWeight < ApplicationRecord
  belongs_to :transport_model

  validates :start_range, :end_range, :price_for_kg, presence: true
  validates :price_for_kg, numericality: { greater_than_or_equal_to: 0 }
  validates :end_range, numericality: { greater_than: ->(object) { object.start_range || 0 } }
  validate :start_range_equal_past_end_range, :start_range_inside_range,
           :end_range_inside_range, :end_range_greater_than_maximum_weight

  def start_range_equal_past_end_range
    past_end_range = PriceByWeight.where(transport_model_id: transport_model_id)
                                    .where('end_range <= ?', start_range)
                                    .maximum(:end_range) || transport_model.minimum_weight
    return if past_end_range == start_range

    errors.add(:start_range,
    'não pode ser diferente do valor do peso máximo do intervalo anterior ou menor que o peso mínimo da modalide de transporte')
  end

  def start_range_inside_range
    prices_by_weight_of_transport_model = PriceByWeight.where(transport_model_id: transport_model_id).where.not(id: id)
    ranges = prices_by_weight_of_transport_model.map { |i| (i.start_range..i.end_range - 1) }

    if ranges.any? { |i| i.include?(start_range) }
      errors.add(:start_range, 'não pode estar incluso entre intervalos já cadastrados')
    end
  end

  def end_range_inside_range
    prices_by_weight_of_transport_model = PriceByWeight.where(transport_model_id: transport_model_id).where.not(id: id)
    ranges = prices_by_weight_of_transport_model.map { |i| (i.start_range + 1..i.end_range) }

    if ranges.any? { |i| i.include?(end_range) }
      errors.add(:end_range, 'não pode estar incluso entre intervalos já cadastrados')
    end
  end

  def end_range_greater_than_maximum_weight
    return if end_range.nil?

    if end_range > transport_model.maximum_weight
      errors.add(:end_range, 'não pode ser maior que o peso máximo da modalidade de transporte')
    end
  end
end

