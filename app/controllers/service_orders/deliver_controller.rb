module ServiceOrders
  class DeliverController < ApplicationController
    before_action :authenticate_user!

    def index
      @service_orders = ServiceOrder.processed
    end

    def edit
      @service_order = ServiceOrder.find(params[:id])
    end

    def create
      @service_order = ServiceOrder.find(params[:id])

      success, errors = ServiceOrders::Deliver.perform(@service_order, service_order_params)
      if success
        flash[:notice] = 'Ordem de Serviço encerrada com sucesso.'
        redirect_to service_order_path(@service_order)
      else
        flash = {notice: 'Não foi possível encerrar ordem de serviço.', service_order_errors: errors}
        redirect_to edit_service_orders_deliver_path(@service_order), flash: flash
      end
    end

    private

    def service_order_params
      params.require(:service_order).permit(:delivery_description)
    end
  end
end
