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
end
