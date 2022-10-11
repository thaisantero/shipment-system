require 'rails_helper'

describe 'Usuário edita um veículo' do
  it 'se for administrador' do
    user = User.create!(name: 'User', email: 'user@sistemadefrete.com.br', password: 'password', role: :regular_user)
    transport_model = TransportModel.create!(
      name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
      maximum_weight: 10_000, fixed_rate: 10
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

    expect(current_path).to eq vehicles_path
    expect(page).not_to have_link('Editar')
  end

  it 'visualizando dados cadastrados' do
    user = User.create!(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :admin)
    transport_model = TransportModel.create!(
      name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
      maximum_weight: 10_000, fixed_rate: 10
    )
    Vehicle.create!(
      identification_plate: 'PNG-0000', vehicle_brand: 'Volkswagen',
      vehicle_type: 'Van 1.6 Mi', fabrication_year: 2016,
      max_load_capacity: 10_000, transport_model: transport_model, status: :waiting
    )

    login_as(user)
    visit root_path
    click_on 'Veículos'
    click_on 'Editar'

    expect(page).to have_content('Editar Veículo')
    expect(page).to have_field('Placa de Identificação', with: 'PNG-0000')
    expect(page).to have_field('Marca', with: 'Volkswagen')
    expect(page).to have_field('Modelo', with: 'Van 1.6 Mi')
    expect(page).to have_field('Ano de Fabricação', with: '2016')
    expect(page).to have_field('Capacidade Máxima de Carga', with: '10000')
  end

  it 'com sucesso' do
    user = User.create!(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :admin)
    transport_model = TransportModel.create!(
      name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
      maximum_weight: 10_000, fixed_rate: 10
    )
    Vehicle.create!(
      identification_plate: 'PNG-0000', vehicle_brand: 'Volkswagen',
      vehicle_type: 'Van 1.6 Mi', fabrication_year: 2016,
      max_load_capacity: 10_000, transport_model: transport_model, status: :waiting
    )

    login_as(user)
    visit root_path
    click_on 'Veículos'
    click_on 'Editar'
    fill_in 'Placa de Identificação', with: 'PXY-1050'
    fill_in 'Marca', with: 'Chevrolet'
    fill_in 'Ano de Fabricação', with: '2020'
    click_on 'Cadastrar'

    expect(page).to have_content('Veículo atualizado com sucesso.')
    expect(page).to have_content('PXY-1050')
    expect(page).to have_content('Chevrolet')
    expect(page).to have_content('2020')
  end

  it 'com dados incompletos' do
    user = User.create!(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :admin)
    transport_model = TransportModel.create!(
      name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
      maximum_weight: 10_000, fixed_rate: 10
    )
    Vehicle.create!(
      identification_plate: 'PNG-0000', vehicle_brand: 'Volkswagen',
      vehicle_type: 'Van 1.6 Mi', fabrication_year: 2016,
      max_load_capacity: 10_000, transport_model: transport_model, status: :waiting
    )

    login_as(user)
    visit root_path
    click_on 'Veículos'
    click_on 'Editar'
    fill_in 'Placa de Identificação', with: ''
    fill_in 'Marca', with: ''
    fill_in 'Modelo', with: ''
    fill_in 'Ano de Fabricação', with: ''
    fill_in 'Capacidade Máxima de Carga', with: ''
    click_on 'Cadastrar'

    expect(page).to have_content('Não foi possível atualizar veículo')
    expect(page).to have_content('Placa de Identificação não pode ficar em branco')
    expect(page).to have_content('Marca não pode ficar em branco')
    expect(page).to have_content('Modelo não pode ficar em branco')
    expect(page).to have_content('Ano de Fabricação não pode ficar em branco')
    expect(page).to have_content('Capacidade Máxima de Carga não pode ficar em branco')
  end
end
