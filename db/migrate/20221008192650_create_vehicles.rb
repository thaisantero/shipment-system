class CreateVehicles < ActiveRecord::Migration[7.0]
  def change
    create_table :vehicles do |t|
      t.string :identification_plate
      t.string :vehicle_brand
      t.string :vehicle_type
      t.integer :fabrication_year
      t.integer :max_load_capacity

      t.timestamps
    end
  end
end
