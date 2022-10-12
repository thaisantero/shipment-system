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
      flash.now[:notice] = 'Taxa por Distância não cadastrado.'
      redirect_to transport_model_path(params[:transport_model_id])
    end
  end

  private

  def price_by_distance_params
    params.require(:price_by_distance).permit(
      :start_range, :end_range, :distance_tax
    ).merge({transport_model_id: params[:transport_model_id]})
  end
end
