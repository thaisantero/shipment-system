require 'rails_helper'

describe 'Usuário remove prazo estimado por distância' do
  it 'sendo administrador' do
    user = User.create!(name: 'User', email: 'user@sistemadefrete.com.br', password: 'password')
    tm = TransportModel.create!(
      name: 'Bike', minimum_distance: 1, maximum_distance: 10, minimum_weight: 1,
      maximum_weight: 10, fixed_rate: 5, status: 'disabled'
    )
    DeliveryTimeTable.create!(start_range: 1, end_range: 10, delivery_time: 10, transport_model: tm)

    login_as(user)
    visit root_path
    click_on 'Modelos de Transporte'
    click_on 'Bike'

    expect(page).not_to have_link 'Remover'
  end

  it 'com sucesso' do
    user = User.create!(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :admin)
    tm = TransportModel.create!(
      name: 'Bike', minimum_distance: 1, maximum_distance: 10, minimum_weight: 1,
      maximum_weight: 10, fixed_rate: 5, status: 'disabled'
    )
    DeliveryTimeTable.create!(start_range: 1, end_range: 10, delivery_time: 10, transport_model: tm)

    login_as(user)
    visit root_path
    click_on 'Modelos de Transporte'
    click_on 'Bike'
    click_on 'Remover'

    expect(page).to have_content 'Prazo Estimado de Entrega por Distância removido com sucesso'
    expect(page).not_to have_content '1 km'
    expect(page).not_to have_content '5 km'
    expect(page).not_to have_content '10 h'
  end
end
