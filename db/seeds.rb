# frozen_string_literal: true
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
User.create!(email: 'maria@sistemadefrete.com.br', password: 'senha123', name: 'Maria Sales', role: :admin)
User.create!(email: 'joao@sistemadefrete.com.br', password: 'senha123', name: 'João Oliveira', role: :regular_user)

t1 = TransportModel.create!(name: 'Express', minimum_distance: 100, maximum_distance: 500,
                            minimum_weight: 10, maximum_weight: 500, fixed_rate: 20)

t2 = TransportModel.create!(name: 'Sedex', minimum_distance: 100, maximum_distance: 500,
                            minimum_weight: 10, maximum_weight: 500, fixed_rate: 15)

t3 = TransportModel.create!(name: 'Local', minimum_distance: 0, maximum_distance: 20,
                            minimum_weight: 0, maximum_weight: 20, fixed_rate: 5)

t4 = TransportModel.create!(name: 'Ecológica', minimum_distance: 0, maximum_distance: 20,
                            minimum_weight: 0, maximum_weight: 20, fixed_rate: 10)

5.times do |i|
  Vehicle.create!(identification_plate: "PNG100#{i}", vehicle_brand: "Marca 1#{i}",
                  vehicle_type: "Modelo 1#{i}", fabrication_year: 2015 + i, max_load_capacity: 500,
                  transport_model: t1)
end

5.times do |i|
  Vehicle.create!(identification_plate: "PNG200#{i}", vehicle_brand: "Marca 2#{i}",
                  vehicle_type: "Modelo 2#{i}", fabrication_year: 2015 + i, max_load_capacity: 500,
                  transport_model: t2)
end

5.times do |i|
  Vehicle.create!(identification_plate: "PNG300#{i}", vehicle_brand: "Marca 3#{i}",
                  vehicle_type: "Modelo 3#{i}", fabrication_year: 2015 + i, max_load_capacity: 20,
                  transport_model: t3)
end

5.times do |i|
  Vehicle.create!(identification_plate: "PNG400#{i}", vehicle_brand: "Marca 4#{i}",
                  vehicle_type: "Modelo 4#{i}", fabrication_year: 2015 + i, max_load_capacity: 20,
                  transport_model: t4)
end

starts_distance_t1_t2 = [100, 200, 300, 400]
ends_distance_t1_t2 = [200, 300, 400, 500]

starts_distance_t3_t4 = [0, 5, 10, 15]
ends_distance_t3_t4 = [5, 10, 15, 20]

4.times do |i|
  PriceByDistance.create!(start_range: starts_distance_t1_t2[i], end_range: ends_distance_t1_t2[i],
                          distance_tax: 10 + (i * 0.5), transport_model: t1)
end

4.times do |i|
  PriceByDistance.create!(start_range: starts_distance_t1_t2[i], end_range: ends_distance_t1_t2[i],
                          distance_tax: 5 + (i * 0.5), transport_model: t2)
end

4.times do |i|
  PriceByDistance.create!(start_range: starts_distance_t3_t4[i], end_range: ends_distance_t3_t4[i],
                          distance_tax: 5 + (i * 0.5), transport_model: t3)
end

4.times do |i|
  PriceByDistance.create!(start_range: starts_distance_t3_t4[i], end_range: ends_distance_t3_t4[i],
                          distance_tax: 10 + (i * 0.5), transport_model: t4)
end

starts_weight_t1_t2 = [10, 100, 200, 300, 400]
ends_weight_t1_t2 = [100, 200, 300, 400, 500]

starts_weight_t3_t4 = [0, 5, 10, 15]
ends_weight_t3_t4 = [5, 10, 15, 20]

5.times do |i|
  PriceByWeight.create!(start_range: starts_weight_t1_t2[i], end_range: ends_weight_t1_t2[i],
                        price_for_kg: 0.2 + (i * 0.1), transport_model: t1)
end

5.times do |i|
  PriceByWeight.create!(start_range: starts_weight_t1_t2[i], end_range: ends_weight_t1_t2[i],
                        price_for_kg: 0.1 + (i * 0.1), transport_model: t2)
end

4.times do |i|
  PriceByWeight.create!(start_range: starts_weight_t3_t4[i], end_range: ends_weight_t3_t4[i],
                        price_for_kg: 1 + (i * 0.1), transport_model: t3)
end

4.times do |i|
  PriceByWeight.create!(start_range: starts_weight_t3_t4[i], end_range: ends_weight_t3_t4[i],
                        price_for_kg: 2 + (i * 0.1), transport_model: t4)
end

4.times do |i|
  DeliveryTimeTable.create!(start_range: starts_distance_t1_t2[i], end_range: ends_distance_t1_t2[i],
                            delivery_time: 12 * (i + 1), transport_model: t1)
end

4.times do |i|
  DeliveryTimeTable.create!(start_range: starts_distance_t1_t2[i], end_range: ends_distance_t1_t2[i],
                            delivery_time: 24 * (i + 1), transport_model: t2)
end

4.times do |i|
  DeliveryTimeTable.create!(start_range: starts_distance_t3_t4[i], end_range: ends_distance_t3_t4[i],
                            delivery_time: i + 1, transport_model: t3)
end

4.times do |i|
  DeliveryTimeTable.create!(start_range: starts_distance_t3_t4[i], end_range: ends_distance_t3_t4[i],
                            delivery_time: (i + 1) * 2, transport_model: t4)
end

10.times do |i|
  customer = Customer.create!(customer_address: "Rua Raul Seixas, 1#{i}", customer_cep: "5000000#{i}",
                              customer_name: "Rita Lee #{i}", customer_registration_number: "1234567891#{i}")
  service_order = ServiceOrder.create!(pickup_address: "Rua Elis, 1#{i}", pickup_cep: "7000000#{i}",
                                       delivery_distance: (i + 1) * 50, customer:)
  Product.create!(length: 100, width: 90, height: 80, weight: 100.4, service_order:)
end

10.times do |i|
  customer = Customer.create!(customer_address: "Rua Chico Buarque, 1#{i}", customer_cep: "4000000#{i}",
                              customer_name: "Tim Maia #{i}", customer_registration_number: "1234567892#{i}")
  service_order = ServiceOrder.create!(pickup_address: "Rua Ariano Suassuna, 1#{i}", pickup_cep: "4000000#{i}",
                                       delivery_distance: (i + 1) * 2, customer:)
  Product.create!(length: 100, width: 90, height: 80, weight: 12, service_order:)
end
