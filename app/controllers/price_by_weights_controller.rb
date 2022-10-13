class PriceByWeightsController < ApplicationController
  before_action :authenticate_user!

  def new
    @price_by_weight = PriceByWeight.new
  end

  def create
    @price_by_weight = PriceByWeight.new(price_by_weight_params)
    if @price_by_weight.save
      flash[:notice] = 'Preço por Distância cadastrado com sucesso.'
      redirect_to transport_model_path(@price_by_weight.transport_model_id)
    else
      flash.now[:notice] = 'Preço por Distância não cadastrado.'
      redirect_to transport_model_path(params[:transport_model_id])
    end
  end

  private

  def price_by_weight_params
    params.require(:price_by_weight).permit(
      :start_range, :end_range, :price_for_kg
    ).merge({transport_model_id: params[:transport_model_id]})
  end
end
