# frozen_string_literal: true

class CreateDeliveryTimeTables < ActiveRecord::Migration[7.0]
  def change
    create_table :delivery_time_tables do |t|
      t.integer :start_range
      t.integer :end_range
      t.integer :delivery_time
      t.references :transport_model, null: false, foreign_key: true

      t.timestamps
    end
  end
end
