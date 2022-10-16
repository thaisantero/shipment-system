# frozen_string_literal: true

require 'rails_helper'

describe 'Usuário cadastra novo preço por peso' do
  it 'sendo administrador' do
    user = User.create(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :regular_user)
    tm = TransportModel.create(
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
    user = User.create(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :admin)
    TransportModel.create(
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
    expect(page).to have_content '1 kg'
    expect(page).to have_content '4 kg'
    expect(page).to have_content 'R$2,20'
  end

  it 'de forma indequada e visualiza mensagens de aviso' do
    user = User.create(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :admin)
    TransportModel.create(
      name: 'Bike', minimum_distance: 1, maximum_distance: 10, minimum_weight: 1,
      maximum_weight: 10, fixed_rate: 5, status: 'disabled'
    )

    login_as(user)
    visit root_path
    click_on 'Modelos de Transporte'
    click_on 'Bike'

    within('div#form.price_by_weight') do
      fill_in 'Peso Mínimo', with: 3
      fill_in 'Peso Máximo', with: 2
      fill_in 'Preço por Peso', with: -1
      click_on 'Cadastrar Preço por Peso'
    end

    expect(page).to have_content 'Preço por Peso não cadastrado'
    expect(page).not_to have_content '3 kg'
    expect(page).not_to have_content '2 kg'
    expect(page).not_to have_content 'R$-1,00'
    expect(page).to have_content 'Verifique os erros abaixo:'
    expect(page).to have_content 'Peso Máximo deve ser maior do que 3'
    expect(page).to have_content 'Peso Mínimo não pode ser diferente do valor do peso máximo do intervalo anterior ou menor que o peso mínimo da modalide de transporte'
    expect(page).to have_content 'Preço por Peso deve ser maior ou igual a 0'
  end
end
