class VehiclesController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  def index
    vehicles_active = Vehicle.all.select{ | v | v[:status] == "active" }
    vehicles_maintenance = Vehicle.all.select{ | v | v[:status] == "maintenance" }
    vehicles_waiting = Vehicle.all.select{ | v | v[:status] == "waiting" }
    @vehicles_ordered = [vehicles_active, vehicles_maintenance, vehicles_waiting]
  end
end