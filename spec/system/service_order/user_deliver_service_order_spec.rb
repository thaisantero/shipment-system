require 'rails_helper'

describe 'Usuário vê tela de encerramento da ordem de serviço' do
  it 'sendo usuário regular' do
    user = User.create!(name: 'User', email: 'user@sistemadefrete.com.br', password: 'password', role: :regular_user)
    customer = Customer.create!(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
      customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ASDFGB456FGT7A7')
    transport_model = TransportModel.create!(
      name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
      maximum_weight: 10_000, fixed_rate: 10, status: 'active'
    )
    vehicle = Vehicle.create!(identification_plate: 'PNG0000', vehicle_brand: 'Volkswagen',vehicle_type: 'Van 1.6 Mi',
                              fabrication_year: 2016, max_load_capacity: 10_000, transport_model: transport_model,
                              status: 'waiting')
    estimated_delivery_date = Time.zone.now + 5.days
    service_order = ServiceOrder.create!(pickup_address: 'Rua Baronesa, 10', pickup_cep: '60400455', customer: customer,
                                         delivery_distance: 70.5, transport_model:, vehicle:, estimated_delivery_date:, service_order_status: :processed)
    Product.create!(length: 100, width: 70, height: 80, weight: 12.4, service_order: service_order)

    login_as(user)
    visit root_path
    click_on 'Ordens de Serviço'
    click_on 'Processadas'
    click_on 'Encerrar'

    expect(page).to have_field('Descrição da Entrega')
    expect(page).to have_button('Encerrar')
  end

  it 'e encerra ordem de serviço' do
    user = User.create!(name: 'User', email: 'user@sistemadefrete.com.br', password: 'password', role: :regular_user)
    customer = Customer.create!(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
      customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ASDFGB456FGT7A7')
    transport_model = TransportModel.create!(
      name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
      maximum_weight: 10_000, fixed_rate: 10, status: 'active'
    )
    vehicle = Vehicle.create!(identification_plate: 'PNG0000', vehicle_brand: 'Volkswagen',vehicle_type: 'Van 1.6 Mi',
                              fabrication_year: 2016, max_load_capacity: 10_000, transport_model: transport_model,
                              status: 'waiting')
    estimated_delivery_date = Time.zone.now - 5.days
    service_order = ServiceOrder.create!(pickup_address: 'Rua Baronesa, 10', pickup_cep: '60400455', customer: customer,
                                         delivery_distance: 55, transport_model:, vehicle:, estimated_delivery_date:, 
                                         service_order_status: :processed)
    Product.create!(length: 100, width: 70, height: 80, weight: 12.4, service_order: service_order)

    login_as(user)
    visit root_path
    click_on 'Ordens de Serviço'
    click_on 'Processadas'
    click_on 'Encerrar'
    fill_in 'Descrição da Entrega', with: 'Problema com o veículo de entrega'
    click_on 'Encerrar'

    expect(page).to have_content 'Ordem de Serviço: ASDFGB456FGT7A7'
    expect(page).to have_content 'Endereço de Retirada: Rua Baronesa, 10'
    expect(page).to have_content 'CEP de Retirada: 60400-455'
    expect(page).to have_content 'Dimensões do Produto (C x L x A): 100cm x 70cm x 80cm'
    expect(page).to have_content 'Peso do Produto: 12,40kg'
    expect(page).to have_content 'Endereço de Entrega: Rua Padre Filó, 24'
    expect(page).to have_content 'CEP da Entrega: 60500-344'
    expect(page).to have_content 'Nome do Cliente: Ana Paula Silva Oliveira'
    expect(page).to have_content 'CPF do Cliente: 003.556.112-24'
    expect(page).to have_content 'Distância de Entrega: 55,0 km'
    expect(page).to have_content 'Status: Encerrada'
    expect(page).to have_content 'Modalidade de Transporte: Express'
    expect(page).to have_content "Data Estimada para Entrega: #{estimated_delivery_date.strftime('%d/%m/%Y %H h')}"
    expect(page).to have_content 'Veículo Alocado: PNG0000'
    expect(page).to have_content "Data de Entrega: #{Time.zone.now.strftime('%d/%m/%Y %H h')}"
    expect(page).to have_content 'Status da Entrega: Com Atraso'
    expect(page).to have_content 'Descrição da Entrega: Problema com o veículo de entrega'
  end
end
