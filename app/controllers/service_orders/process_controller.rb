module ServiceOrders
  class ProcessController < ApplicationController
    before_action :authenticate_user!

    def index
      @service_orders = ServiceOrder.pending
    end

    def create
      @service_order = ServiceOrder.find(params[:id])
      transport_model = TransportModel.find(params[:service_order][:transport_model_id])
      if ServiceOrders::Processor.perform(@service_order, transport_model)
        flash[:notice] = 'Ordem de Serviço processada com sucesso.'
        redirect_to service_order_path(@service_order)
      else
        flash.now[:notice] = 'Não foi possível processar a ordem de serviço.'
        redirect_to edit_service_orders_process_path(@service_order)
      end
    end

    def edit
      @service_order = ServiceOrder.find(params[:id])
      @available_transport_models = TransportModel.by_distance(@service_order.delivery_distance).with_vehicles_available.active
    end

    private

    def service_order_params
      params.require(:service_order).permit(
        :transport_model_id
      )
    end
  end
end
