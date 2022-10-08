require 'rails_helper'

describe 'Usuário desativa modelo de transporte' do
  it 'se for administrador(a)' do
    user = User.create!(name: 'User', email: 'user@sistemadefrete.com.br', password: 'password', role: :regular_user)
    TransportModel.create(name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
                          maximum_weight: 10_000, fixed_rate: 10)

    # Act
    login_as(user)
    visit root_path
    click_on 'Modelos de Transporte'

    expect(current_path).to eq transport_models_path
    expect(page).to have_content('Ativo')
    expect(page).not_to have_button('Ativo')
  end

  it 'com sucesso' do
    user = User.create!(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :admin)
    TransportModel.create(name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
                          maximum_weight: 10_000, fixed_rate: 10, status: 'active')
    # Act
    login_as(user)
    visit root_path
    click_on 'Modelos de Transporte'
    click_on 'Ativo'

    # Assert
    expect(current_path).to eq transport_models_path
    expect(page).to have_content('Modelo Express foi desativado.')
    expect(page).not_to have_content('Ativo')
    expect(page).to have_content('Desativado')
  end

  it 'e o ativa' do
    user = User.create!(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :admin)
    TransportModel.create(name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
                          maximum_weight: 10_000, fixed_rate: 10, status: 'active')
    # Act
    login_as(user)
    visit root_path
    click_on 'Modelos de Transporte'
    click_on 'Ativo'
    click_on 'Desativado'

    # Assert
    expect(current_path).to eq transport_models_path
    expect(page).to have_content('Modelo Express foi ativado.')
    expect(page).to have_content('Ativo')
    expect(page).not_to have_content('Desativado')
  end
end
