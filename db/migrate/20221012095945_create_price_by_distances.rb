class CreatePriceByDistances < ActiveRecord::Migration[7.0]
  def change
    create_table :price_by_distances do |t|
      t.integer :start_range
      t.integer :end_range
      t.decimal :price_for_km
      t.references :transport_model, null: false, foreign_key: true

      t.timestamps
    end
  end
end