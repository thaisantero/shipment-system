class DeliveryTimeTableController < ApplicationController
  before_action :authenticate_user!

  def new
    @delivery_time_table = DeliveryTimeTable.new
  end

  def create
    @delivery_time_table = DeliveryTimeTable.new(delivery_time_table_params)
    if @delivery_time_table.save
      flash[:notice] = 'Prazo Estimado de Entrega por Distância cadastrado com sucesso.'
      redirect_to transport_model_path(@delivery_time_table.transport_model_id)
    else
      flash[:notice] = 'Prazo Estimado de Entrega por Distância não cadastrado.'
      redirect_to transport_model_path(delivery_time_table_params[:transport_model_id]), flash: {delivery_time_table_errors: @delivery_time_table.errors.full_messages}
    end
  end

  def edit
    @delivery_time_table = DeliveryTimeTable.find(params[:id])
  end

  def update
    @delivery_time_table = DeliveryTimeTable.find(params[:id])

    if @delivery_time_table.update(delivery_time_table_params)
      flash[:notice] = 'Prazo Estimado de Entrega por Distância atualizado com sucesso.'
      redirect_to transport_model_path(@delivery_time_table.transport_model)
    else
      flash[:notice] = 'Prazo Estimado de Entrega por Distância não atualizado.'
      render 'edit'
    end
  end

  def destroy
    @delivery_time_table = DeliveryTimeTable.find(params[:id])
    @delivery_time_table.destroy
    flash[:notice] = 'Prazo Estimado de Entrega por Distância removido com sucesso.'
    redirect_to transport_model_path(@delivery_time_table.transport_model)
  end

  private

  def delivery_time_table_params
    params.require(:delivery_time_table).permit(
      :start_range, :end_range, :delivery_time, :transport_model_id
    )
  end
end
