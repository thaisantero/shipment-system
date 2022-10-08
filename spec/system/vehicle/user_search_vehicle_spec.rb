require 'rails_helper'

describe 'Usuário busca veículo' do
  it 'a partir da página de veículos' do
    user = User.create!(name: 'User', email: 'user@sistemadefrete.com.br', password: 'password')

    login_as(user)
    visit root_path
    click_on 'Veículos'
    within('header nav') do
      expect(page).to have_field('Buscar Veículo')
      expect(page).to have_button('Buscar')
    end
  end

  it 'e deve estar autenticado' do
    visit root_path
    click_on 'Veículos'
    within('header nav') do
      expect(page).not_to have_field('Buscar Veículo')
      expect(page).not_to have_button('Buscar')
    end
  end

  it 'e encontra um veículo' do
    user = User.create!(name: 'User', email: 'user@sistemadefrete.com.br', password: 'password')
    transport_model = TransportModel.create(
      name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
      maximum_weight: 10_000, fixed_rate: 10, status: 'active'
    )
    Vehicle.create(
      identification_plate: 'PNG-0000', vehicle_brand: 'Volkswagen', 
      vehicle_type: 'Van 1.6 Mi', fabrication_year: 2016,
      max_load_capacity: 10_000, transport_model: transport_model
    )
    Vehicle.create(
      identification_plate: 'TCU-3432', vehicle_brand: 'Fiat', 
      vehicle_type: 'Fiat 1.8', fabrication_year: 2020,
      max_load_capacity: 1000, transport_model: transport_model
    )

    login_as(user)
    visit root_path
    click_on 'Veículos'
    fill_in 'Buscar Veículo', with: 'Van'
    click_on 'Buscar'

    expect(page).to have_content '1 veículo encontrado'
    expect(page).to have_content 'PNG-0000'
    expect(page).to have_content 'Volkswagen'
    expect(page).to have_content 'Van 1.6 Mi'
    expect(page).not_to have_content 'TCU-3432'
    expect(page).not_to have_content 'Fiat 1.8'
  end

  it 'e encontra um múltiplos veículos' do
    user = User.create!(name: 'User', email: 'user@sistemadefrete.com.br', password: 'password')
    transport_model = TransportModel.create(
      name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
      maximum_weight: 10_000, fixed_rate: 10, status: 'active'
    )
    Vehicle.create(
      identification_plate: 'PNG-0000', vehicle_brand: 'Volkswagen', 
      vehicle_type: 'Van 1.6 Mi', fabrication_year: 2016,
      max_load_capacity: 10_000, transport_model: transport_model
    )
    Vehicle.create(
      identification_plate: 'TCU-3432', vehicle_brand: 'Fiat', 
      vehicle_type: 'Fiat 1.8', fabrication_year: 2020,
      max_load_capacity: 1000, transport_model: transport_model
    )
    Vehicle.create(
      identification_plate: 'BTV-4040', vehicle_brand: 'Fiat', 
      vehicle_type: 'Fiat Uno', fabrication_year: 2019,
      max_load_capacity: 1000, transport_model: transport_model
    )

    login_as(user)
    visit root_path
    click_on 'Veículos'
    fill_in 'Buscar Veículo', with: 'Fiat'
    click_on 'Buscar'

    expect(page).to have_content '2 veículos encontrados'
    expect(page).not_to have_content 'PNG-0000'
    expect(page).not_to have_content 'Volkswagen'
    expect(page).not_to have_content 'Van 1.6 Mi'
    expect(page).to have_content 'TCU-3432'
    expect(page).to have_content 'Fiat 1.8'
    expect(page).to have_content 'BTV-4040'
    expect(page).to have_content 'Fiat Uno'
  end
end
