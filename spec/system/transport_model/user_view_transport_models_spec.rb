# frozen_string_literal: true

require 'rails_helper'

describe 'Usuário vê modelos de transporte cadastrados' do
  it 'se estiver autenticado' do
    visit root_path
    click_on 'Modelos de Transporte'

    expect(current_path).to eq new_user_session_path
  end

  it 'a partir do menu' do
    # Arrange
    user = User.create(name: 'User', email: 'user@sistemadefrete.com.br', password: 'password')
    TransportModel.create(name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
                          maximum_weight: 10_000, fixed_rate: 10, status: 'active')
    TransportModel.create(name: 'Bike', minimum_distance: 1, maximum_distance: 10, minimum_weight: 1,
                          maximum_weight: 10, fixed_rate: 5, status: 'disabled')

    # Act
    login_as(user)
    visit root_path
    click_on 'Modelos de Transporte'

    # Assert
    expect(page).not_to have_content('Nao existem modelos de transporte cadastrados')

    expect(page).to have_content('Taxa Fixa')
    expect(page).to have_content('Situação')
    expect(page).to have_content('Express')
    expect(page).to have_content('R$10,00')
    expect(page).to have_content('Ativo')
    expect(page).to have_content('Bike')
    expect(page).to have_content('R$5,00')
    expect(page).to have_content('Desativado')
  end
end
