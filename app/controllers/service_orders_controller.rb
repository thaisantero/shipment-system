# frozen_string_literal: true

class ServiceOrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @service_orders = ServiceOrder.all.sort_by(&:service_order_status)
  end

  def new
    @service_order = ServiceOrder.new
  end

  def create
    @service_order = ServiceOrder.new(service_order_params)

    if @service_order.save
      flash[:notice] = 'Ordem de Serviço cadastrada com sucesso.'
      redirect_to service_orders_path
    else
      flash.now[:notice] = 'Ordem de Serviço não cadastrada.'
      render 'new'
    end
  end

  def show
    @service_order = ServiceOrder.find(params[:id])
  end

  private

  def service_order_params
    params.require(:service_order).permit(
      :pickup_address, :pickup_cep,
      :delivery_distance,
      product_attributes: %i[length width height weight],
      customer_attributes: %i[customer_address customer_cep customer_name customer_registration_number]
    )
  end
end
