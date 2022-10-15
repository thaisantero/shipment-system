class AddEstimatedDeliveryDateToServiceOrder < ActiveRecord::Migration[7.0]
  def change
    add_column :service_orders, :estimated_delivery_date, :datetime
  end
end
