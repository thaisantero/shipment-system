# frozen_string_literal: true

class AddStatusToTransportModel < ActiveRecord::Migration[7.0]
  def change
    add_column :transport_models, :status, :integer, default: 5
  end
end
