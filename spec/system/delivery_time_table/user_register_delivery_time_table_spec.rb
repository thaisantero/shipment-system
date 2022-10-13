require 'rails_helper'

describe 'Usuário cadastra novo prazo estimado por intervalo de distância' do
  it 'sendo administrador' do
    user = User.create!(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :regular_user)
    tm = TransportModel.create!(
      name: 'Bike', minimum_distance: 1, maximum_distance: 10, minimum_weight: 1,
      maximum_weight: 10, fixed_rate: 5, status: 'disabled'
    )

    login_as(user)
    visit root_path
    click_on 'Modelos de Transporte'
    click_on 'Bike'

    expect(page).not_to have_field 'Distância Mínima'
    expect(page).not_to have_field 'Distância Máxima'
    expect(page).not_to have_field 'Prazo Estimado'
  end

  it 'com sucesso' do
    user = User.create!(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :admin)
    TransportModel.create!(
      name: 'Bike', minimum_distance: 1, maximum_distance: 10, minimum_weight: 1,
      maximum_weight: 10, fixed_rate: 5, status: 'disabled'
    )

    login_as(user)
    visit root_path
    click_on 'Modelos de Transporte'
    click_on 'Bike'

    within('div#form.delivery_time_table') do
      fill_in 'Distância Mínima', with: 1
      fill_in 'Distância Máxima', with: 4
      fill_in 'Prazo Estimado', with: 4
      click_on 'Cadastrar Prazo Estimado'
    end

    expect(page).to have_content 'Distância Mínima'
    expect(page).to have_content 'Distância Máxima'
    expect(page).to have_content 'Prazo Estimado'
    expect(page).to have_content '1 km'
    expect(page).to have_content '4 km'
    expect(page).to have_content '4 h'
  end
end
