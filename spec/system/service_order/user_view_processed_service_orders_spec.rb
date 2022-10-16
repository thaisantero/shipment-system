# frozen_string_literal: true

require 'rails_helper'

describe 'Usuário vê ordens de serviço processadas' do
  it 'sendo usuário regular' do
    user = User.create(name: 'User', email: 'user@sistemadefrete.com.br', password: 'password', role: :regular_user)
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
    estimated_delivery_date = Time.zone.now + 5.days
    processed_date = Time.zone.now
    service_order = ServiceOrder.create(pickup_address: 'Rua Baronesa, 10', pickup_cep: '60400455', customer:,
                                        delivery_distance: 70.5, transport_model:, vehicle:, estimated_delivery_date:, service_order_status: :processed,
                                        processed_date:)
    Product.create(length: 100, width: 70, height: 80, weight: 12.4, service_order:)

    login_as(user)
    visit root_path
    click_on 'Ordens de Serviço'
    click_on 'Processadas'

    expect(page).not_to have_content('Nao existem ordens de serviço cadastradas')
    expect(page).to have_content('Código')
    expect(page).to have_content('Endereço de Entrega')
    expect(page).to have_content('Distância de Entrega')
    expect(page).to have_content('Modalidade de Transporte')
    expect(page).to have_content('Veículo Alocado')
    expect(page).to have_content('Data de Processamento')
    expect(page).to have_content('Data Estimada para Entrega')
    expect(page).to have_content('ASDFGB456FGT7A7')
    expect(page).to have_content('Rua Padre Filó, 24(60500-344)')
    expect(page).to have_content('70,5 km')
    expect(page).to have_content('Express')
    expect(page).to have_content('PNG0000')
    expect(page).to have_content Time.zone.now.strftime('%d/%m/%Y %H h')
    expect(page).to have_content estimated_delivery_date.strftime('%d/%m/%Y %H h')
  end
end
