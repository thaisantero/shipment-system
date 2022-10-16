# frozen_string_literal: true

class VehiclesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_vehicle, only: %i[edit update]

  def index
    @vehicles = Vehicle.all.in_order_of(:status, [5, 0, 10])
  end

  def new
    @vehicle = Vehicle.new
    @transport_models = TransportModel.all
  end

  def create
    @vehicle = Vehicle.new(vehicle_params)
    if @vehicle.save
      redirect_to vehicles_path, notice: 'Veículo cadastrado com sucesso.'
    else
      @transport_models = TransportModel.all
      flash.now[:alert] = 'Veículo não cadastrado.'
      render 'new'
    end
  end

  def update
    if @vehicle.update(vehicle_params)
      redirect_to vehicles_path, notice: 'Veículo atualizado com sucesso.'
    else
      flash.now[:notice] = 'Não foi possível atualizar veículo.'
      @transport_models = TransportModel.all
      render 'edit'
    end
  end

  def edit
    @transport_models = TransportModel.all
  end

  def search
    @query = params[:query]
    @vehicles = Vehicle.where(
      'identification_plate LIKE ? OR vehicle_brand LIKE ? OR vehicle_type LIKE ?
      OR fabrication_year LIKE ? OR max_load_capacity LIKE ? OR transport_model_id LIKE ?', "%#{@query}%",
      "%#{@query}%", "%#{@query}%", "%#{@query}%", "%#{@query}%", "%#{@query}%"
    )
  end

  private

  def set_vehicle
    @vehicle = Vehicle.find(params[:id])
  end

  def vehicle_params
    params.require(:vehicle).permit(
      :identification_plate, :vehicle_brand, :vehicle_type,
      :fabrication_year, :max_load_capacity, :transport_model_id, :status
    )
  end
end
