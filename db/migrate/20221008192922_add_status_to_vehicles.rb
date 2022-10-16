# frozen_string_literal: true

class AddStatusToVehicles < ActiveRecord::Migration[7.0]
  def change
    add_column :vehicles, :status, :integer, default: 0
  end
end
