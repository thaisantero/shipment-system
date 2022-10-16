class AddProcessedDateToServiceOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :service_orders, :processed_date, :datetime
  end
end
