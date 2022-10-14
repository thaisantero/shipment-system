class ServiceOrder < ApplicationRecord
  belongs_to :transport_model, optional: true
  belongs_to :vehicle, optional: true
  belongs_to :customer
  has_one :product
  accepts_nested_attributes_for :product

  enum service_order_status: { pending: 0, processed: 5, delivered: 10 }

  before_create :generate_code

  private

  def generate_code
    self.code = SecureRandom.alphanumeric(15).upcase
  end
end
