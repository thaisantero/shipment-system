# frozen_string_literal: true

require 'rails_helper'

describe 'Usuário cadastra novo preço por intervalo de distância' do
  it 'sendo administrador' do
    user = User.create(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :regular_user)
    _tm = TransportModel.create(
      name: 'Bike', minimum_distance: 1, maximum_distance: 10, minimum_weight: 1,
      maximum_weight: 10, fixed_rate: 5, status: 'disabled'
    )

    login_as(user)
    visit root_path
    click_on 'Modelos de Transporte'
    click_on 'Bike'

    expect(page).not_to have_field 'Distância Mínima'
    expect(page).not_to have_field 'Distância Máxima'
    expect(page).not_to have_field 'Taxa por Distância'
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

    within('div#form.price_by_distance') do
      fill_in 'Distância Mínima', with: 1
      fill_in 'Distância Máxima', with: 4
      fill_in 'Taxa por Distância', with: 2.2
      click_on 'Cadastrar Taxa por Distância'
    end

    expect(page).to have_content 'Distância Mínima'
    expect(page).to have_content 'Distância Máxima'
    expect(page).to have_content 'Taxa por Distância'
    expect(page).to have_content '1 km'
    expect(page).to have_content '4 km'
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

    within('div#form.price_by_distance') do
      fill_in 'Distância Mínima', with: 3
      fill_in 'Distância Máxima', with: 2
      fill_in 'Taxa por Distância', with: -1
      click_on 'Cadastrar Taxa por Distância'
    end

    expect(page).to have_content 'Taxa por Distância não cadastrada'
    expect(page).not_to have_content '3 km'
    expect(page).not_to have_content '2 km'
    expect(page).not_to have_content 'R$-1,00'
    expect(page).to have_content 'Verifique os erros abaixo:'
    expect(page).to have_content 'Distância Máxima deve ser maior do que 3'
    expect(page).to have_content 'Distância Mínima não pode ser diferente do valor da distância máxima do intervalo anterior ou menor que distância mínima da modalide de transporte'
    expect(page).to have_content 'Taxa por Distância deve ser maior ou igual a 0'
  end
end
