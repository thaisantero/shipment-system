require 'rails_helper'

describe 'Usuário cadastra veículo' do
  it 'se estiver autenticado' do
    visit new_vehicle_path

    expect(current_path).to eq new_user_session_path
  end

  it 'se for administrador' do
    # Arrange
    user = User.create!(name: 'User', email: 'user@sistemadefrete.com.br', password: 'password', role: :regular_user)
    # Act
    login_as(user)
    visit root_path
    click_on 'Veículos'

    # Assert
    expect(page).not_to have_link('Cadastrar novo veículo')
  end

  it 'com sucesso' do
    # Arrange
    user = User.create!(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :admin)
    TransportModel.create(
      name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
      maximum_weight: 10_000, fixed_rate: 10, status: 'active'
    )
    # Act
    login_as(user)
    visit root_path
    click_on 'Veículos'
    click_on 'Cadastrar novo veículo'
    fill_in 'Placa de Identificação', with: 'PTU2234'
    fill_in 'Marca', with: 'Fiat'
    fill_in 'Modelo', with: 'Fiat Scudo'
    fill_in 'Ano de Fabricação', with: 2018
    fill_in 'Capacidade Máxima de Carga', with: 10_000
    select 'Express', from: 'Modelo de Transporte'
    click_on 'Cadastrar'

    # Assert
    expect(current_path).to eq vehicles_path
    expect(page).to have_content 'Veículo cadastrado com sucesso.'
    expect(page).to have_content('Express')
    expect(page).to have_content('PTU2234')
    expect(page).to have_content('Fiat')
    expect(page).to have_content('Fiat Scudo')
    expect(page).to have_content('2018')
    expect(page).to have_content('10000kg')
  end

  it 'com dados incompletos' do
    # Arrange
    user = User.create!(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :admin)
    TransportModel.create(
      name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
      maximum_weight: 10_000, fixed_rate: 10, status: 'active'
    )
    # Act
    login_as(user)
    visit root_path
    click_on 'Veículos'
    click_on 'Cadastrar novo veículo'
    fill_in 'Placa de Identificação', with: ''
    fill_in 'Marca', with: ''
    fill_in 'Modelo', with: ''
    fill_in 'Ano de Fabricação', with: ''
    fill_in 'Capacidade Máxima de Carga', with: ''
    click_on 'Cadastrar'

    # Assert
    expect(page).to have_content('Veículo não cadastrado.')
    expect(page).to have_content('Placa de Identificação não pode ficar em branco')
    expect(page).to have_content('Marca não pode ficar em branco')
    expect(page).to have_content('Modelo não pode ficar em branco')
    expect(page).to have_content('Ano de Fabricação não pode ficar em branco')
    expect(page).to have_content('Capacidade Máxima de Carga não pode ficar em branco')
  end
end
