require 'rails_helper'

describe 'Usuário cadastra modelo de transporte' do
  it 'se for administrador' do
    # Arrange
    user = User.create!(name: 'User', email: 'user@sistemadefrete.com.br', password: 'password', role: :regular_user)
    # Act
    login_as(user)
    visit root_path
    click_on 'Modelos de Transporte'

    # Assert
    expect(page).not_to have_link('Cadastrar novo modelo de transporte')
  end

  it 'com sucesso' do
    # Arrange
    user = User.create!(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :admin)
    # Act
    login_as(user)
    visit root_path
    click_on 'Modelos de Transporte'
    click_on 'Cadastrar novo modelo de transporte'
    fill_in 'Nome', with: 'Sedex'
    fill_in 'Distância Mínima', with: 200
    fill_in 'Distância Máxima', with: 4000
    fill_in 'Peso Mínimo', with: 100
    fill_in 'Peso Máximo', with: 1000
    fill_in 'Taxa Fixa', with: 50
    click_on 'Cadastrar'

    # Assert
    expect(current_path).to eq transport_models_path
    expect(page).to have_content 'Modelo de Transporte cadastrado com sucesso.'
    expect(page).to have_content('Sedex')
    expect(page).to have_content('200 - 4000km')
    expect(page).to have_content('100 - 1000kg')
    expect(page).to have_content('R$50,00')
  end
end
