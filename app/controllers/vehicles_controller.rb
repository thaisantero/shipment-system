class VehiclesController < ApplicationController
  before_action :authenticate_user!

  def index
    vehicles_active = Vehicle.all.select{ | v | v[:status] == "active" }
    vehicles_maintenance = Vehicle.all.select{ | v | v[:status] == "maintenance" }
    vehicles_waiting = Vehicle.all.select{ | v | v[:status] == "waiting" }
    @vehicles = [vehicles_active, vehicles_maintenance, vehicles_waiting]
  end

  def search
    @query = params[:query]
    @vehicles = Vehicle.where(
      'identification_plate LIKE ? OR vehicle_brand LIKE ? OR vehicle_type LIKE ?
      OR fabrication_year LIKE ? OR max_load_capacity LIKE ? OR transport_model_id LIKE ?', "%#{@query}%",
      "%#{@query}%", "%#{@query}%", "%#{@query}%", "%#{@query}%", "%#{@query}%"
    )
  end

  def new
    @vehicle = Vehicle.new
    @transport_models = TransportModel.all
  end

  def create
    vehicle_params = params.require(:vehicle).permit(
      :identification_plate, :vehicle_brand, :vehicle_type,
      :fabrication_year, :max_load_capacity, :transport_model_id, :status
  )

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
    # debugger
    vehicle_params = params.require(:vehicle).permit(
      :identification_plate, :vehicle_brand, :vehicle_type,
      :fabrication_year, :max_load_capacity, :transport_model_id, :status
    )
    @vehicle = Vehicle.find(params[:id])
    @vehicle.update(vehicle_params)
    redirect_to vehicles_path, notice: 'Veículo atualizado com sucesso.'
  end
end
