class PriceByDistance < ApplicationRecord
  belongs_to :transport_model

  validates :start_range, :end_range, :distance_tax, presence: true
  validates_uniqueness_of :start_range, :end_range
  validates :end_range, numericality: { greater_than: :start_range }
  validate :start_range_equal_past_end_range, :start_range_inside_range,
           :end_range_inside_range, :end_range_greater_than_maximum_distance

  def start_range_equal_past_end_range
    past_end_range = PriceByDistance.where(transport_model_id: transport_model_id)
                                    .where('end_range <= ?', start_range)
                                    .maximum(:end_range) || transport_model.minimum_distance
    return if past_end_range == start_range

    errors.add(:start_range, "não pode ser diferente do valor da distância máxima do intervalo anterior #{past_end_range}")
  end

  def start_range_inside_range
    prices_by_distances_of_transport_model = PriceByDistance.where(transport_model_id: transport_model_id)
    ranges = prices_by_distances_of_transport_model.map { |i| (i.start_range + 1..i.end_range - 1) }

    if ranges.any? { |i| i.include?(start_range) }
      errors.add(:start_range, 'não pode estar incluso entre intervalos já cadastrados')
    end
  end

  def end_range_inside_range
    prices_by_distances_of_transport_model = PriceByDistance.where(transport_model_id: transport_model_id)
    ranges = prices_by_distances_of_transport_model.map { |i| (i.start_range + 1..i.end_range - 1) }

    if ranges.any? { |i| i.include?(end_range) }
      errors.add(:end_range, 'não pode estar incluso entre intervalos já cadastrados')
    end
  end

  def end_range_greater_than_maximum_distance
    if end_range > transport_model.maximum_distance
      errors.add(:end_range, 'não pode ser maior que máxima distância da modalidade de transporte')
    end
  end
end
