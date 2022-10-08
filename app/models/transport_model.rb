class TransportModel < ApplicationRecord
  enum status: { active: 5, disabled: 10 }
  validates :name, :minimum_distance, :maximum_distance, :fixed_rate, presence: true
  validates :minimum_distance, :maximum_distance, :fixed_rate, :minimum_weight,
            :maximum_weight, numericality: { greater_than_or_equal_to: 0, :message => "não pode ser negativa"}
end
