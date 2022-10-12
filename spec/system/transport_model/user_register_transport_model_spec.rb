require 'rails_helper'

describe 'Usuário cadastra modelo de transporte' do
  it 'se estver autenticado' do
    visit new_transport_model_path

    expect(current_path).to eq new_user_session_path
  end

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
    expect(page).to have_content 'Modelo de Transporte cadastrado com sucesso.'
    expect(page).to have_content('Intervalo de Distância aceitável: 200 - 4000km')
    expect(page).to have_content('Intervalo de Peso suportável: 100 - 1000kg')
    expect(page).to have_content('Taxa Fixa: R$50,00')
    expect(page).to have_content('Situação: Ativo')
  end

  it 'com dados incompletos' do
    # Arrange
    user = User.create!(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :admin)
    # Act
    login_as(user)
    visit root_path
    click_on 'Modelos de Transporte'
    click_on 'Cadastrar novo modelo de transporte'
    fill_in 'Nome', with: ''
    fill_in 'Distância Mínima', with: ''
    fill_in 'Distância Máxima', with: ''
    fill_in 'Peso Mínimo', with: ''
    fill_in 'Peso Máximo', with: ''
    fill_in 'Taxa Fixa', with: ''
    click_on 'Cadastrar'

    # Assert
    expect(page).to have_content('Modelo de Transporte não cadastrado.')
    expect(page).to have_content('Nome não pode ficar em branco')
    expect(page).to have_content('Distância Mínima não pode ficar em branco')
    expect(page).to have_content('Distância Máxima não pode ficar em branco')
    expect(page).not_to have_content('Peso Mínimo não pode ficar em branco')
    expect(page).not_to have_content('Peso Máximo não pode ficar em branco')
    expect(page).to have_content('Taxa Fixa não pode ficar em branco')
  end
end
