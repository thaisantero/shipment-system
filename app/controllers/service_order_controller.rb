class ServiceOrderController < ApplicationController
  before_action :authenticate_user!

  def index
    @service_orders = ServiceOrder.all.sort_by(&:service_order_status)
  end
end
