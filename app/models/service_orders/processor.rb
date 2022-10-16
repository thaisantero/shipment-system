# frozen_string_literal: true

module ServiceOrders
  class Processor
    attr_reader :service_order, :transport_model

    def self.perform(service_order, transport_model)
      new(service_order, transport_model).perform
    end

    def initialize(service_order, transport_model)
      @service_order = service_order
      @transport_model = transport_model
    end

    def perform
      service_order.estimated_delivery_date = calculate_estimated_delivery_date
      service_order.processed_date = Time.zone.now
      service_order.vehicle = vehicle
      service_order.transport_model = transport_model
      service_order.delivery_price = calculate_shipping_price
      service_order.processed!
      vehicle.active!
    end

    private

    def calculate_estimated_delivery_date
      delivery_time = transport_model.delivery_time(service_order.delivery_distance)
      Time.zone.now + delivery_time.hours
    end

    def vehicle
      transport_model.vehicles.waiting.first
    end

    def calculate_shipping_price
      transport_model.shipping_price(service_order.product.weight, service_order.delivery_distance)
    end
  end
end
