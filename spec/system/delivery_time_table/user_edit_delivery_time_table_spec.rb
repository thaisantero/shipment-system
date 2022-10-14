require 'rails_helper'

describe 'Usuário edita um prazo estimado de entrega por distância' do
  it 'se for administrador' do
    user = User.create!(name: 'User', email: 'user@sistemadefrete.com.br', password: 'password', role: :regular_user)
    tm = TransportModel.create(name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
                          maximum_weight: 10_000, fixed_rate: 10)
    DeliveryTimeTable.create!(start_range: 50, end_range: 100, delivery_time: 10, transport_model: tm)
    # Act
    login_as(user)
    visit root_path
    click_on 'Modelos de Transporte'
    click_on 'Express'

    expect(page).not_to have_link('Editar')
  end

  it 'visualizando dados cadastrados' do
    user = User.create!(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :admin)
    tm = TransportModel.create(name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
                               maximum_weight: 10_000, fixed_rate: 10)
    DeliveryTimeTable.create!(start_range: 50, end_range: 100, delivery_time: 10, transport_model: tm)

    login_as(user)
    visit root_path
    click_on 'Modelos de Transporte'
    click_on 'Express'
    click_on 'Editar'

    expect(page).to have_content('Editar Prazo Estimado de Entrega por Distância')
    expect(page).to have_field('Distância Mínima', with: 50)
    expect(page).to have_field('Distância Máxima', with: 100)
    expect(page).to have_field('Prazo Estimado de Entrega', with: 10)
  end

  it 'com sucesso' do
    user = User.create!(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :admin)
    tm = TransportModel.create!(
      name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
      maximum_weight: 10_000, fixed_rate: 10
    )
    DeliveryTimeTable.create!(start_range: 50, end_range: 100, delivery_time: 10, transport_model: tm)

    login_as(user)
    visit root_path
    click_on 'Modelos de Transporte'
    click_on 'Express'
    click_on 'Editar'
    fill_in 'Distância Mínima', with: 50
    fill_in 'Distância Máxima', with: 80
    fill_in 'Prazo Estimado de Entrega', with: 15
    click_on 'Cadastrar Prazo Estimado de Entrega por Distância'

    expect(page).to have_content('Prazo Estimado de Entrega por Distância atualizado com sucesso.')
    expect(page).to have_content('50 km')
    expect(page).to have_content('80 km')
    expect(page).to have_content('15 h')
  end

  it 'e mantém os campos obrigatórios' do
    user = User.create!(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :admin)
    tm = TransportModel.create(name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
                          maximum_weight: 10_000, fixed_rate: 10)
    DeliveryTimeTable.create!(start_range: 50, end_range: 100, delivery_time: 10, transport_model: tm)

    login_as(user)
    visit root_path
    click_on 'Modelos de Transporte'
    click_on 'Express'
    click_on 'Editar'
    fill_in 'Distância Mínima', with: ''
    fill_in 'Distância Máxima', with: 80
    fill_in 'Prazo Estimado de Entrega', with: 15
    click_on 'Cadastrar Prazo Estimado de Entrega por Distância'

    expect(page).to have_content('Prazo Estimado de Entrega por Distância não atualizado.')
  end
end
