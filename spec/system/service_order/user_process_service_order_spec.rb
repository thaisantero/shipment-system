# frozen_string_literal: true

require 'rails_helper'

describe 'Usuário vê modalidades de transporte disponíveis para alocação' do
  it 'sendo usuário regular' do
    user = User.create(name: 'User', email: 'user@sistemadefrete.com.br', password: 'password', role: :regular_user)
    customer = Customer.create(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
                                customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ASDFGB456FGT7A7')
    service_order = ServiceOrder.create(pickup_address: 'Rua Baronesa, 10', pickup_cep: '60400455', customer:,
                                         delivery_distance: 55)
    Product.create(length: 100, width: 70, height: 80, weight: 12.4, service_order:)
    transport_model = TransportModel.create(
      name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
      maximum_weight: 10_000, fixed_rate: 10, status: 'active'
    )
    PriceByDistance.create(start_range: 50, end_range: 60, distance_tax: 5, transport_model:)
    PriceByWeight.create(start_range: 10, end_range: 200, price_for_kg: 0.2, transport_model:)
    DeliveryTimeTable.create(start_range: 50, end_range: 60, delivery_time: 5, transport_model:)
    Vehicle.create(identification_plate: 'PNG0000', vehicle_brand: 'Volkswagen', vehicle_type: 'Van 1.6 Mi',
                    fabrication_year: 2016, max_load_capacity: 10_000, transport_model:,
                    status: 'waiting')

    login_as(user)
    visit root_path
    click_on 'Ordens de Serviço'
    click_on 'Pendentes'
    click_on 'Alocar Modalidade de Transporte'

    expect(page).not_to have_content('Nao existem ordens de serviço cadastradas')
    expect(page).to have_content('Modalidades de Transporte Disponíveis')
    expect(page).to have_content('Express')
    expect(page).to have_content('Preço da Modalidade')
    expect(page).to have_content('Prazo Estimado para Entrega')
    expect(page).to have_content('R$26,00')
    expect(page).to have_content('5 h')
  end

  it 'e escolhe modalidade de transporte' do
    user = User.create(name: 'User', email: 'user@sistemadefrete.com.br', password: 'password', role: :regular_user)
    customer = Customer.create(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
                                customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ASDFGB456FGT7A7')
    service_order = ServiceOrder.create(pickup_address: 'Rua Baronesa, 10', pickup_cep: '60400455', customer:,
                                         delivery_distance: 55)
    Product.create(length: 100, width: 70, height: 80, weight: 12.4, service_order:)
    transport_model = TransportModel.create(
      name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
      maximum_weight: 10_000, fixed_rate: 10, status: 'active'
    )
    PriceByDistance.create(start_range: 50, end_range: 60, distance_tax: 5, transport_model:)
    PriceByWeight.create(start_range: 10, end_range: 200, price_for_kg: 0.2, transport_model:)
    delivery_time = DeliveryTimeTable.create(start_range: 50, end_range: 60, delivery_time: 48, transport_model:)
    Vehicle.create(identification_plate: 'PNG0000', vehicle_brand: 'Volkswagen', vehicle_type: 'Van 1.6 Mi',
                    fabrication_year: 2016, max_load_capacity: 10_000, transport_model:,
                    status: 'waiting')
    delivery_estimated_date = Time.zone.now + delivery_time.delivery_time.hours

    login_as(user)
    visit root_path
    click_on 'Ordens de Serviço'
    click_on 'Pendentes'
    click_on 'Alocar Modalidade de Transporte'
    choose 'Express'
    click_on 'Alocar'

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
    expect(page).to have_content 'Status: Em Entrega'
    expect(page).to have_content 'Modalidade de Transporte: Express'
    expect(page).to have_content "Data Estimada para Entrega: #{delivery_estimated_date.strftime('%d/%m/%Y %H h')}"
    expect(page).to have_content 'Veículo Alocado: PNG0000'
    expect(page).to have_content 'Valor do Frete: R$26,0'
  end
end
