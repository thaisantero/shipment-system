# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 20_221_015_172_809) do
  create_table 'customers', force: :cascade do |t|
    t.string 'customer_address'
    t.string 'customer_cep'
    t.string 'customer_name'
    t.string 'customer_registration_number'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'delivery_time_tables', force: :cascade do |t|
    t.integer 'start_range'
    t.integer 'end_range'
    t.integer 'delivery_time'
    t.integer 'transport_model_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['transport_model_id'], name: 'index_delivery_time_tables_on_transport_model_id'
  end

  create_table 'price_by_distances', force: :cascade do |t|
    t.integer 'start_range'
    t.integer 'end_range'
    t.decimal 'distance_tax'
    t.integer 'transport_model_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['transport_model_id'], name: 'index_price_by_distances_on_transport_model_id'
  end

  create_table 'price_by_weights', force: :cascade do |t|
    t.integer 'start_range'
    t.integer 'end_range'
    t.decimal 'price_for_kg'
    t.integer 'transport_model_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['transport_model_id'], name: 'index_price_by_weights_on_transport_model_id'
  end

  create_table 'products', force: :cascade do |t|
    t.integer 'length'
    t.integer 'width'
    t.integer 'height'
    t.decimal 'weight'
    t.integer 'service_order_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['service_order_id'], name: 'index_products_on_service_order_id'
  end

  create_table 'service_orders', force: :cascade do |t|
    t.string 'code'
    t.string 'pickup_address'
    t.string 'pickup_cep'
    t.decimal 'delivery_distance'
    t.integer 'customer_id', null: false
    t.integer 'service_order_status', default: 0
    t.integer 'transport_model_id'
    t.decimal 'delivery_price'
    t.integer 'vehicle_id'
    t.datetime 'delivery_date'
    t.integer 'delivery_status'
    t.string 'delivery_description'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.datetime 'estimated_delivery_date'
    t.index ['customer_id'], name: 'index_service_orders_on_customer_id'
    t.index ['transport_model_id'], name: 'index_service_orders_on_transport_model_id'
    t.index ['vehicle_id'], name: 'index_service_orders_on_vehicle_id'
  end

  create_table 'transport_models', force: :cascade do |t|
    t.string 'name'
    t.integer 'minimum_distance'
    t.integer 'maximum_distance'
    t.integer 'minimum_weight'
    t.integer 'maximum_weight'
    t.integer 'fixed_rate'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'status', default: 5
  end

  create_table 'users', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'role', default: 5
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
  end

  create_table 'vehicles', force: :cascade do |t|
    t.string 'identification_plate'
    t.string 'vehicle_brand'
    t.string 'vehicle_type'
    t.integer 'fabrication_year'
    t.integer 'max_load_capacity'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.integer 'status', default: 0
    t.integer 'transport_model_id', null: false
    t.index ['transport_model_id'], name: 'index_vehicles_on_transport_model_id'
  end

  add_foreign_key 'delivery_time_tables', 'transport_models'
  add_foreign_key 'price_by_distances', 'transport_models'
  add_foreign_key 'price_by_weights', 'transport_models'
  add_foreign_key 'products', 'service_orders'
  add_foreign_key 'service_orders', 'customers'
  add_foreign_key 'service_orders', 'transport_models'
  add_foreign_key 'service_orders', 'vehicles'
  add_foreign_key 'vehicles', 'transport_models'
end
