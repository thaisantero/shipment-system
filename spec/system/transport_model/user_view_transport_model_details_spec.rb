# frozen_string_literal: true

require 'rails_helper'

describe 'Usuário vê detalhes do modelo de transporte' do
  it 'se estiver autenticado' do
    transport_model = TransportModel.create(
      name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
      maximum_weight: 10_000, fixed_rate: 10, status: 'active'
    )

    visit transport_model_path(transport_model.id)

    expect(current_path).to eq new_user_session_path
  end

  it 'sendo usuário regular' do
    # Arrange
    user = User.create(name: 'User', email: 'user@sistemadefrete.com.br', password: 'password', role: :regular_user)
    TransportModel.create(
      name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
      maximum_weight: 10_000, fixed_rate: 10, status: 'active'
    )

    # Act
    login_as(user)
    visit root_path
    click_on 'Modelos de Transporte'
    click_on 'Express'

    # Assert
    expect(page).to have_content('Intervalo de Distância aceitável: 50 - 200km')
    expect(page).to have_content('Intervalo de Peso suportável: 10 - 10000kg')
    expect(page).to have_content('Taxa Fixa: R$10,00')
    expect(page).to have_content('Situação: Ativo')
  end

  it 'sendo administrador' do
    # Arrange
    user = User.create(name: 'User', email: 'user@sistemadefrete.com.br', password: 'password', role: :admin)
    TransportModel.create(
      name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
      maximum_weight: 10_000, fixed_rate: 10, status: 'active'
    )

    # Act
    login_as(user)
    visit root_path
    click_on 'Modelos de Transporte'
    click_on 'Express'

    # Assert
    expect(page).to have_content('Intervalo de Distância aceitável: 50 - 200km')
    expect(page).to have_content('Intervalo de Peso suportável: 10 - 10000kg')
    expect(page).to have_content('Taxa Fixa: R$10,00')
    expect(page).to have_content('Situação: Ativo')
  end
end
