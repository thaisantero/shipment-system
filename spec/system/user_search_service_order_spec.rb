require 'rails_helper'

describe 'Usuário busca ordem de serviço' do
  it 'em entrega' do
    customer = Customer.create(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
                               customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ASDFGB456FGT7A7')
    transport_model = TransportModel.create(
      name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
      maximum_weight: 10_000, fixed_rate: 10, status: 'active'
    )
    vehicle = Vehicle.create(identification_plate: 'PNG0000', vehicle_brand: 'Volkswagen', vehicle_type: 'Van 1.6 Mi',
                             fabrication_year: 2016, max_load_capacity: 10_000, transport_model:,
                             status: 'waiting')
    estimated_delivery_date = Time.zone.now - 5.days
    processed_date = Time.zone.now - 10.days
    service_order = ServiceOrder.create(pickup_address: 'Rua Baronesa, 10', pickup_cep: '60400455', customer:,
                                        delivery_distance: 55, transport_model:, vehicle:, estimated_delivery_date:,
                                        service_order_status: :processed, delivery_price: 40, processed_date:)
    Product.create(length: 100, width: 70, height: 80, weight: 12.4, service_order:)

    visit root_path
    fill_in 'Insira Código de Rastreio', with: 'ASDFGB456FGT7A7'
    click_on 'Buscar'

    expect(page).to have_content 'Endereço de Retirada'
    expect(page).to have_content 'Endereço de Entrega'
    expect(page).to have_content 'Status'
    expect(page).to have_content 'Data de Processamento'
    expect(page).to have_content 'Placa de Identificação do Veículo'
    expect(page).to have_content 'Modelo do Veículo'
    expect(page).to have_content 'Data Estimada para Entrega'
    expect(page).to have_content 'Rua Baronesa, 10'
    expect(page).to have_content 'Rua Padre Filó, 24'
    expect(page).to have_content 'Em Entrega'
    expect(page).to have_content processed_date.strftime('%d/%m/%Y %H h').to_s
    expect(page).to have_content 'PNG0000'
    expect(page).to have_content 'Van 1.6 Mi'
    expect(page).to have_content estimated_delivery_date.strftime('%d/%m/%Y %H h').to_s
  end

  it 'encerrada' do
    customer = Customer.create(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
                               customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ASDFGB456FGT7A7')
    transport_model = TransportModel.create(
      name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
      maximum_weight: 10_000, fixed_rate: 10, status: 'active'
    )
    vehicle = Vehicle.create(identification_plate: 'PNG0000', vehicle_brand: 'Volkswagen', vehicle_type: 'Van 1.6 Mi',
                             fabrication_year: 2016, max_load_capacity: 10_000, transport_model:,
                             status: 'waiting')
    estimated_delivery_date = Time.zone.now - 5.days
    processed_date = Time.zone.now - 10.days
    service_order = ServiceOrder.create(pickup_address: 'Rua Baronesa, 10', pickup_cep: '60400455', customer:,
                                        delivery_distance: 55, transport_model:, vehicle:, estimated_delivery_date:,
                                        service_order_status: :delivered, delivery_price: 40, delivery_date: Time.zone.now,
                                        processed_date:, delivery_status: :with_delay,
                                        delivery_description: 'Problema com veículo de entrega')
    Product.create(length: 100, width: 70, height: 80, weight: 12.4, service_order:)

    visit root_path
    fill_in 'Insira Código de Rastreio', with: 'ASDFGB456FGT7A7'
    click_on 'Buscar'

    expect(page).to have_content 'Endereço de Retirada'
    expect(page).to have_content 'Endereço de Entrega'
    expect(page).to have_content 'Status'
    expect(page).to have_content 'Data de Processamento'
    expect(page).to have_content 'Placa de Identificação do Veículo'
    expect(page).to have_content 'Modelo do Veículo'
    expect(page).to have_content 'Data de Entrega'
    expect(page).to have_content 'Descrição da Entrega'
    expect(page).to have_content 'Rua Baronesa, 10'
    expect(page).to have_content 'Rua Padre Filó, 24'
    expect(page).to have_content 'Encerrada'
    expect(page).to have_content processed_date.strftime('%d/%m/%Y %H h').to_s
    expect(page).to have_content 'PNG0000'
    expect(page).to have_content 'Van 1.6 Mi'
    expect(page).to have_content Time.zone.now.strftime('%d/%m/%Y %H h').to_s
    expect(page).to have_content 'Problema com veículo de entrega'
  end

  it 'pendente' do
    customer = Customer.create(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
                               customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ASDFGB456FGT7A7')
    transport_model = TransportModel.create(
      name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
      maximum_weight: 10_000, fixed_rate: 10, status: 'active'
    )
    vehicle = Vehicle.create(identification_plate: 'PNG0000', vehicle_brand: 'Volkswagen', vehicle_type: 'Van 1.6 Mi',
                             fabrication_year: 2016, max_load_capacity: 10_000, transport_model:,
                             status: 'waiting')
    service_order = ServiceOrder.create(pickup_address: 'Rua Baronesa, 10', pickup_cep: '60400455', customer:,
                                        delivery_distance: 55, transport_model:, vehicle:,
                                        service_order_status: :pending)
    Product.create(length: 100, width: 70, height: 80, weight: 12.4, service_order:)

    visit root_path
    fill_in 'Insira Código de Rastreio', with: 'ASDFGB456FGT7A7'
    click_on 'Buscar'

    expect(page).to have_content 'Endereço de Retirada'
    expect(page).to have_content 'Endereço de Entrega'
    expect(page).to have_content 'Status'
    expect(page).to have_content 'Rua Baronesa, 10'
    expect(page).to have_content 'Rua Padre Filó, 24'
    expect(page).to have_content 'Pendente'
  end
end
