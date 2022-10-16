# frozen_string_literal: true

class ServiceOrder < ApplicationRecord
  belongs_to :transport_model, optional: true
  belongs_to :vehicle, optional: true
  belongs_to :customer
  has_one :product
  accepts_nested_attributes_for :customer, :product

  enum service_order_status: { pending: 0, processed: 5, delivered: 10 }
  enum delivery_status: { on_time: 0, with_delay: 10 }

  validates :pickup_address, :pickup_cep, :delivery_distance, presence: true
  validates :delivery_distance, numericality: { greater_than_or_equal_to: 0 }
  validates :pickup_cep, length: { is: 8 }
  validates :pickup_cep, numericality: { only_integer: true }
  validates :delivery_description, presence: true, if: -> { with_delay? }

  scope :search, ->(query) {
    if query.present?
      where(
        'code LIKE :query OR service_order_status LIKE :query OR delivery_status LIKE :query', 
        query: "%#{query}%"
      )
    end
  }

  before_create :generate_code

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(15)
  end
end
