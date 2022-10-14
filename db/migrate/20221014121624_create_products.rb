class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.integer :length
      t.integer :width
      t.integer :height
      t.decimal :weight
      t.references :service_order, null: false, foreign_key: true

      t.timestamps
    end
  end
end
