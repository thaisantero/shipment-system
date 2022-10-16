# frozen_string_literal: true

class TransportModel < ApplicationRecord
  enum status: { active: 5, disabled: 10 }

  validates :name, :minimum_distance, :maximum_distance, :minimum_weight, :maximum_weight, :fixed_rate, presence: true
  validates :minimum_distance, :maximum_distance, :fixed_rate, :minimum_weight,
            :maximum_weight, numericality: { greater_than_or_equal_to: 0, message: 'não pode ser negativa' }

  has_many :vehicles
  has_many :price_by_distances
  has_many :price_by_weights
  has_many :delivery_time_tables
  has_many :service_orders

  scope :by_distance, lambda { |distance|
                        where('minimum_distance <= :distance AND maximum_distance >= :distance', distance:)
                      }
  scope :with_vehicles_available, -> { where(id: Vehicle.select(:transport_model_id).waiting) }

  def shipping_price(weight, distance)
    fixed_rate + tax_distance(distance) + tax_weight(weight, distance)
  end

  def tax_distance(distance)
    available_ranges = price_by_distances.where('start_range <= :distance AND end_range > :distance',
                                                distance:)
    return 0 if available_ranges.empty?

    available_ranges.first.distance_tax
  end

  def tax_weight(weight, distance)
    available_ranges = price_by_weights.where('start_range <= :weight AND end_range > :weight', weight:)
    return 0 if available_ranges.empty?

    available_ranges.first.price_for_kg * distance
  end

  def delivery_time(distance)
    available_ranges = delivery_time_tables.where('start_range <= :distance AND end_range > :distance',
                                                  distance:)
    return 0 if available_ranges.empty?

    available_ranges.first.delivery_time
  end
end
