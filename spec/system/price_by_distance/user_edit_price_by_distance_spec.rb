require 'rails_helper'

describe 'Usuário edita um preço por distância' do
  it 'se for administrador' do
    user = User.create!(name: 'User', email: 'user@sistemadefrete.com.br', password: 'password', role: :regular_user)
    TransportModel.create(name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
                          maximum_weight: 10_000, fixed_rate: 10)

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
    PriceByDistance.create!(start_range: 50, end_range: 100, distance_tax: 10, transport_model: tm)

    login_as(user)
    visit root_path
    click_on 'Modelos de Transporte'
    click_on 'Express'
    click_on 'Editar'

    expect(page).to have_content('Editar Taxa por Distância')
    expect(page).to have_field('Distância Mínima', with: 50)
    expect(page).to have_field('Distância Máxima', with: 100)
    expect(page).to have_field('Taxa por Distância', with: 10.0)
  end
end