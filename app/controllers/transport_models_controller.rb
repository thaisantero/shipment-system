class TransportModelsController < ApplicationController
  before_action :authenticate_user!
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
      redirect_to transport_model_path(@transport_model.id)
    else
      flash.now[:notice] = 'Modelo de Transporte não cadastrado.'
      render 'new'
    end
  end

  def edit
    @transport_model = TransportModel.find(params[:id])
  end

  def update
    @transport_model = TransportModel.find(params[:id])

    if @transport_model.update(transport_model_params)
      flash[:notice] = 'Modelo de Transporte atualizado com sucesso.'
      redirect_to transport_model_path(@transport_model.id)
    else
      flash.now[:notice] = 'Não foi possível atualizar o modelo de transporte.'
      render 'edit'
    end
  end

  def show
    @transport_model = TransportModel.find(params[:id])
    @transport_models = TransportModel.all
    @price_by_distances = PriceByDistance.where(transport_model_id: @transport_model.id).sort_by(&:start_range)
    @price_by_distance = PriceByDistance.new
    @price_by_weights = PriceByWeight.where(transport_model_id: @transport_model.id).sort_by(&:start_range)
    @price_by_weight = PriceByWeight.new
    @delivery_times_table = DeliveryTimeTable.where(transport_model_id: @transport_model.id).sort_by(&:start_range)
    @delivery_time_table = DeliveryTimeTable.new
  end

  def change_status
    transport_model = TransportModel.find(params[:id])
    if transport_model.active?
      transport_model.disabled!
      redirect_to transport_models_path, notice: "O Modelo #{transport_model.name} foi desativado."
    else
      transport_model.active!
      redirect_to transport_models_path, notice: "O Modelo #{transport_model.name} foi ativado."
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
