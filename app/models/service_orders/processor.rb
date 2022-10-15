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
      service_order.vehicle = vehicle
      service_order.transport_model = transport_model
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
  end
end
