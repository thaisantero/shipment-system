class TransportModelsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :new, :create]
  def index
    @transport_models = TransportModel.all
  end

  def new
    @transport_model = TransportModel.new
  end

  def create
    @transport_model = TransportModel.new(transport_model_params)

    if @transport_model.save
      flash[:notice] = 'Modelo de Transporte cadastrado com sucesso.'
      redirect_to transport_models_path
    else
      flash.now[:notice] = 'Modelo de Transporte não cadastrado.'
      render 'new'
    end
  end

  private

  def transport_model_params
    params.require(:transport_model).permit(
      :name, :minimum_distance,
      :maximum_distance, :minimum_weight, :maximum_weight, :fixed_rate
    )
  end
end
