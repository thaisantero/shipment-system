# frozen_string_literal: true

module ServiceOrders
  class Deliver
    attr_reader :service_order, :params

    def self.perform(service_order, params)
      new(service_order, params).perform
    end

    def initialize(service_order, params)
      @service_order = service_order
      @params = params
    end

    def perform
      service_order.delivery_description = params[:delivery_description]
      service_order.delivery_date = Time.zone.now
      service_order.delivery_status = delivery_status
      service_order.service_order_status = :delivered
      service_order.vehicle.waiting!
      if service_order.save
        [true, []]
      else
        [false, service_order.errors.full_messages]
      end
    end

    private

    def delivery_status
      if service_order.estimated_delivery_date < Time.zone.now
        :with_delay
      else
        :on_time
      end
    end
  end
end
