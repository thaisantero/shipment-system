class PriceByDistancesController < ApplicationController
  before_action :authenticate_user!

  def new
    @price_by_distance = PriceByDistance.new
  end

  def create
    @price_by_distance = PriceByDistance.new(price_by_distance_params)
    if @price_by_distance.save
      flash[:notice] = 'Taxa por Distância cadastrado com sucesso.'
      redirect_to transport_model_path(@price_by_distance.transport_model_id)
    else
      flash[:notice] = 'Taxa por Distância não cadastrada.'
      redirect_to transport_model_path(price_by_distance_params[:transport_model_id]), flash: {price_by_distance_errors: @price_by_distance.errors.full_messages}
    end
  end

  def edit
    @price_by_distance = PriceByDistance.find(params[:id])
  end

  def update
    @price_by_distance = PriceByDistance.find(params[:id])

    if @price_by_distance.update(price_by_distance_params)
      flash[:notice] = 'Taxa por Distância atualizada com sucesso.'
      redirect_to transport_model_path(@price_by_distance.transport_model)
    else
      flash.now[:notice] = 'Taxa por Distância não atualizada.'
      render 'edit'
    end
  end


  def destroy
    @price_by_distance = PriceByDistance.find(params[:id])
    @price_by_distance.destroy
    flash[:notice] = 'Taxa por Distância removida com sucesso.'
    redirect_to transport_model_path(@price_by_distance.transport_model)
  end

  private

  def price_by_distance_params
    params.require(:price_by_distance).permit(
      :start_range, :end_range, :distance_tax, :transport_model_id
    )
  end
end
