require 'rails_helper'

describe 'Usuário muda status do veículo' do
  it 'se estiver autenticado' do
    visit vehicles_path

    expect(current_path).to eq new_user_session_path
  end

  it 'se for administrador' do
    # Arrange
    user = User.create!(name: 'User', email: 'user@sistemadefrete.com.br', password: 'password', role: :regular_user)
    transport_model = TransportModel.create(
      name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
      maximum_weight: 10_000, fixed_rate: 10, status: 'active'
    )
    Vehicle.create!(
      identification_plate: 'PNG-0000', vehicle_brand: 'Volkswagen', 
      vehicle_type: 'Van 1.6 Mi', fabrication_year: 2016,
      max_load_capacity: 10_000, transport_model: transport_model, status: :waiting
    )
    # Act
    login_as(user)
    visit root_path
    click_on 'Veículos'

    # Assert
    expect(page).to have_content('Em Espera')
    expect(page).not_to have_button('Em Manutenção')
    expect(page).not_to have_button('Ativo')
  end

  it 'para ativo' do
    # Arrange
    user = User.create!(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :admin)
    transport_model = TransportModel.create(
      name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
      maximum_weight: 10_000, fixed_rate: 10, status: 'active'
    )
    Vehicle.create!(
      identification_plate: 'PNG-0000', vehicle_brand: 'Volkswagen', 
      vehicle_type: 'Van 1.6 Mi', fabrication_year: 2016,
      max_load_capacity: 10_000, transport_model: transport_model, status: :waiting
    )
    # Act
    login_as(user)
    visit root_path
    click_on 'Veículos'
    click_on 'Ativo'

    # Assert
    expect(page).to have_content('Veículo atualizado com sucesso.')
    expect(page).to have_content('Ativo')
    expect(page).to have_button('Em Espera')
    expect(page).to have_button('Em Manutenção')
    expect(page).not_to have_button('Ativo')
  end

  it 'para em manutenção' do
    # Arrange
    user = User.create!(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :admin)
    transport_model = TransportModel.create(
      name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
      maximum_weight: 10_000, fixed_rate: 10, status: 'active'
    )
    Vehicle.create!(
      identification_plate: 'PNG-0000', vehicle_brand: 'Volkswagen', 
      vehicle_type: 'Van 1.6 Mi', fabrication_year: 2016,
      max_load_capacity: 10_000, transport_model: transport_model, status: :waiting
    )
    # Act
    login_as(user)
    visit root_path
    click_on 'Veículos'
    click_on 'Em Manutenção'

    # Assert
    expect(page).to have_content('Veículo atualizado com sucesso.')
    expect(page).to have_content('Em Manutenção')
    expect(page).to have_button('Em Espera')
    expect(page).not_to have_button('Em Manutenção')
    expect(page).to have_button('Ativo')
  end

  it 'para em espera' do
    # Arrange
    user = User.create!(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :admin)
    transport_model = TransportModel.create(
      name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
      maximum_weight: 10_000, fixed_rate: 10, status: 'active'
    )
    Vehicle.create!(
      identification_plate: 'PNG-0000', vehicle_brand: 'Volkswagen',
      vehicle_type: 'Van 1.6 Mi', fabrication_year: 2016,
      max_load_capacity: 10_000, transport_model: transport_model, status: :active
    )
    # Act
    login_as(user)
    visit root_path
    click_on 'Veículos'
    click_on 'Em Espera'

    # Assert
    expect(page).to have_content('Veículo atualizado com sucesso.')
    expect(page).to have_content('Em Espera')
    expect(page).not_to have_button('Em Espera')
    expect(page).to have_button('Em Manutenção')
    expect(page).to have_button('Ativo')
  end
end
