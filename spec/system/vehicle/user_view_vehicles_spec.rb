# frozen_string_literal: true

require 'rails_helper'

describe 'Usuário vê veículos cadastrados' do
  it 'se estiver autenticado' do
    visit root_path
    click_on 'Veículos'

    expect(current_path).to eq new_user_session_path
  end

  it 'a partir do menu' do
    # Arrange
    user = User.create(name: 'User', email: 'user@sistemadefrete.com.br', password: 'password')
    transport_model = TransportModel.create(
      name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
      maximum_weight: 10_000, fixed_rate: 10, status: 'active'
    )
    Vehicle.create(
      identification_plate: 'PNG0000', vehicle_brand: 'Volkswagen',
      vehicle_type: 'Van 1.6 Mi', fabrication_year: 2016,
      max_load_capacity: 10_000, transport_model:
    )

    # Act
    login_as(user)
    visit root_path
    click_on 'Veículos'

    # Assert
    expect(page).not_to have_content('Nao existem vaículos cadastrados')
    expect(page).to have_content('Placa de Identificação')
    expect(page).to have_content('Marca')
    expect(page).to have_content('Modelo')
    expect(page).to have_content('Ano de Fabricação')
    expect(page).to have_content('Capacidade Máxima de Carga')
    expect(page).to have_content('Modelo de Transporte')
    expect(page).to have_content('Situação')
    expect(page).to have_content('PNG0000')
    expect(page).to have_content('Volkswagen')
    expect(page).to have_content('Van 1.6 Mi')
    expect(page).to have_content('2016')
    expect(page).to have_content('10000')
    expect(page).to have_content('Express')
    expect(page).to have_content('Em Espera')
  end
end
