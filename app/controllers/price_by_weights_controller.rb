# frozen_string_literal: true

class PriceByWeightsController < ApplicationController
  before_action :authenticate_user!

  def new
    @price_by_weight = PriceByWeight.new
  end

  def create
    @price_by_weight = PriceByWeight.new(price_by_weight_params)
    if @price_by_weight.save
      flash[:notice] = 'Preço por Peso cadastrado com sucesso.'
      redirect_to transport_model_path(@price_by_weight.transport_model_id)
    else
      flash[:notice] = 'Preço por Peso não cadastrado.'
      redirect_to transport_model_path(price_by_weight_params[:transport_model_id]),
                  flash: { price_by_weight_errors: @price_by_weight.errors.full_messages }
    end
  end

  def edit
    @price_by_weight = PriceByWeight.find(params[:id])
  end

  def update
    @price_by_weight = PriceByWeight.find(params[:id])

    if @price_by_weight.update(price_by_weight_params)
      flash[:notice] = 'Preço por Peso atualizado com sucesso.'
      redirect_to transport_model_path(@price_by_weight.transport_model)
    else
      flash[:notice] = 'Preço por Peso não atualizado.'
      render 'edit'
    end
  end

  def destroy
    @price_by_weight = PriceByWeight.find(params[:id])
    @price_by_weight.destroy
    flash[:notice] = 'Preço por Peso removido com sucesso.'
    redirect_to transport_model_path(@price_by_weight.transport_model)
  end

  private

  def price_by_weight_params
    params.require(:price_by_weight).permit(
      :start_range, :end_range, :price_for_kg, :transport_model_id
    )
  end
end
