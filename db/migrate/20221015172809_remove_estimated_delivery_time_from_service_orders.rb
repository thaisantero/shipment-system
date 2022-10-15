class RemoveEstimatedDeliveryTimeFromServiceOrders < ActiveRecord::Migration[7.0]
  def change
    remove_column :service_orders, :estimated_delivery_time, :integer
  end
end
