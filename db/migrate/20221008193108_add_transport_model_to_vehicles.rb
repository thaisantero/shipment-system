class AddTransportModelToVehicles < ActiveRecord::Migration[7.0]
  def change
    add_reference :vehicles, :transport_model, null: false, foreign_key: true
  end
end
