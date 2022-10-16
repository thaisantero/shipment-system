# frozen_string_literal: true

module VehicleHelper
  def changeable_status(status)
    Vehicle.statuses.keys - [status]
  end
end
