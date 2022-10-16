# frozen_string_literal: true

require 'rails_helper'

describe 'Usuário edita um preço por peso' do
  it 'se for administrador' do
    user = User.create(name: 'User', email: 'user@sistemadefrete.com.br', password: 'password', role: :regular_user)
    tm = TransportModel.create(name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
                               maximum_weight: 10_000, fixed_rate: 10)
    PriceByWeight.create(start_range: 10, end_range: 100, price_for_kg: 10, transport_model: tm)
    # Act
    login_as(user)
    visit root_path
    click_on 'Modelos de Transporte'
    click_on 'Express'

    expect(page).not_to have_link('Editar')
  end

  it 'visualizando dados cadastrados' do
    user = User.create(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :admin)
    tm = TransportModel.create(name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
                               maximum_weight: 10_000, fixed_rate: 10)
    PriceByWeight.create(start_range: 10, end_range: 100, price_for_kg: 10, transport_model: tm)

    login_as(user)
    visit root_path
    click_on 'Modelos de Transporte'
    click_on 'Express'
    click_on 'Editar'

    expect(page).to have_content('Editar Preço por Peso')
    expect(page).to have_field('Peso Mínimo', with: 10)
    expect(page).to have_field('Peso Máximo', with: 100)
    expect(page).to have_field('Preço por Peso', with: 10.0)
  end

  it 'com sucesso' do
    user = User.create(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :admin)
    tm = TransportModel.create(
      name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
      maximum_weight: 10_000, fixed_rate: 10
    )
    PriceByWeight.create(start_range: 10, end_range: 100, price_for_kg: 10, transport_model: tm)

    login_as(user)
    visit root_path
    click_on 'Modelos de Transporte'
    click_on 'Express'
    click_on 'Editar'
    fill_in 'Peso Mínimo', with: 10
    fill_in 'Peso Máximo', with: 80
    fill_in 'Preço por Peso', with: 15
    click_on 'Cadastrar'

    expect(page).to have_content('Preço por Peso atualizado com sucesso.')
    expect(page).to have_content('10 kg')
    expect(page).to have_content('80 kg')
    expect(page).to have_content('R$15,00')
  end

  it 'e mantém os campos obrigatórios' do
    user = User.create(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :admin)
    tm = TransportModel.create(name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
                               maximum_weight: 10_000, fixed_rate: 10)
    PriceByWeight.create(start_range: 10, end_range: 100, price_for_kg: 10, transport_model: tm)

    login_as(user)
    visit root_path
    click_on 'Modelos de Transporte'
    click_on 'Express'
    click_on 'Editar'
    fill_in 'Peso Mínimo', with: ''
    fill_in 'Peso Máximo', with: 80
    fill_in 'Preço por Peso', with: 15
    click_on 'Cadastrar'

    expect(page).to have_content('Preço por Peso não atualizado.')
  end
end
