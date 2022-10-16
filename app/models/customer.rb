# frozen_string_literal: true

class Customer < ApplicationRecord
  has_many :service_order

  validates :customer_address, :customer_cep, :customer_name, :customer_registration_number, presence: true
  validates :customer_cep, length: { is: 8 }
  validates :customer_registration_number, length: { is: 11 }
  validates :customer_cep, :customer_registration_number, numericality: { only_integer: true }
  validates :customer_registration_number, uniqueness: true
end
