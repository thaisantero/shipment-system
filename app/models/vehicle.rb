class Vehicle < ApplicationRecord
  enum status: { waiting: 0, active: 5, maintenance: 10 }
  belongs_to :transport_model
end
