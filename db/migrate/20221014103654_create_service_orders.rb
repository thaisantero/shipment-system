class CreateServiceOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :service_orders do |t|
      t.string :code
      t.string :pickup_address
      t.string :pickup_cep
      t.decimal :delivery_distance
      t.references :customer, null: false, foreign_key: true
      t.integer :service_order_status, default: 0
      t.references :transport_model, foreign_key: true
      t.integer :estimated_delivery_time
      t.decimal :delivery_price
      t.references :vehicle, foreign_key: true
      t.datetime :delivery_date
      t.integer :delivery_status
      t.string :delivery_description

      t.timestamps
    end
  end
end
