class Vehicle < ApplicationRecord
  enum status: { waiting: 0, active: 5, maintenance: 10 }
  belongs_to :transport_model
  validates :identification_plate, :vehicle_brand, :vehicle_type, :fabrication_year, :max_load_capacity, presence: true
end
