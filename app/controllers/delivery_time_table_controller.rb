class DeliveryTimeTableController < ApplicationController
  before_action :authenticate_user!

  def new
    @delivery_time_table = DeliveryTimeTable.new
  end

  def create
    @delivery_time_table = DeliveryTimeTable.new(delivery_time_table_params)
    if @delivery_time_table.save
      flash[:notice] = 'Prazo Estimado de Entrega cadastrado com sucesso.'
      redirect_to transport_model_path(@delivery_time_table.transport_model_id)
    else
      flash.now[:notice] = 'Prazo Estimado de Entrega não cadastrado.'
      redirect_to transport_model_path(params[:transport_model_id])
    end
  end

  def edit
    @delivery_time_table = DeliveryTimeTable.find(params[:id])
  end

  private

  def delivery_time_table_params
    params.require(:delivery_time_table).permit(
      :start_range, :end_range, :delivery_time
    ).merge({transport_model_id: params[:transport_model_id]})
  end
end
