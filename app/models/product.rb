# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :service_order

  validates :length, :width, :height, :weight, presence: true
  validates :length, :width, :height, :weight, numericality: { greater_than_or_equal_to: 0 }
end
