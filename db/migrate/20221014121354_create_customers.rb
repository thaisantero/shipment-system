# frozen_string_literal: true

class CreateCustomers < ActiveRecord::Migration[7.0]
  def change
    create_table :customers do |t|
      t.string :customer_address
      t.string :customer_cep
      t.string :customer_name
      t.string :customer_registration_number

      t.timestamps
    end
  end
end
