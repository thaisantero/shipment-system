require 'rails_helper'

describe 'Usuário cadastra novo preço por peso' do
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

    expect(page).not_to have_field 'Peso Mínimo'
    expect(page).not_to have_field 'Peso Máximo'
    expect(page).not_to have_field 'Preço por Peso'
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

    within('div#form.price_by_weight') do
      fill_in 'Peso Mínimo', with: 1
      fill_in 'Peso Máximo', with: 4
      fill_in 'Preço por Peso', with: 2.2
      click_on 'Cadastrar Preço por Peso'
    end

    expect(page).to have_content 'Peso Mínimo'
    expect(page).to have_content 'Peso Máximo'
    expect(page).to have_content 'Preço por Peso'
    expect(page).to have_content '1 km'
    expect(page).to have_content '4 km'
    expect(page).to have_content 'R$2,20'
  end
end