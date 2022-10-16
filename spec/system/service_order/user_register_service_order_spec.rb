# frozen_string_literal: true

require 'rails_helper'

describe 'Usuário cadastra modelo de transporte' do
  it 'se for administrador' do
    # Arrange
    user = User.create(name: 'User', email: 'user@sistemadefrete.com.br', password: 'password', role: :regular_user)
    # Act
    login_as(user)
    visit root_path
    click_on 'Ordens de Serviço'

    # Assert
    expect(page).not_to have_link('Cadastrar nova ordem de serviço')
  end

  it 'com sucesso' do
    user = User.create(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :admin)
    allow(SecureRandom).to receive(:alphanumeric).and_return('ASDFGB456FGT7A7')

    login_as(user)
    visit root_path
    click_on 'Ordens de Serviço'
    click_on 'Cadastrar nova ordem de serviço'
    fill_in 'Endereço de Entrega', with: 'Rua Padre Filó, 24'
    fill_in 'CEP da Entrega', with: '60500344'
    fill_in 'Nome do Cliente', with: 'Ana Paula Silva Oliveira'
    fill_in 'CPF do Cliente', with: '00355611224'
    fill_in 'Endereço de Retirada', with: 'Rua Baronesa, 10'
    fill_in 'CEP de Retirada', with: '60400455'
    fill_in 'Distância de Entrega', with: 70.5
    fill_in 'Comprimento do Produto', with: 100
    fill_in 'Largura do Produto', with: 70
    fill_in 'Altura do Produto', with: 80
    fill_in 'Peso do Produto', with: 12.4
    click_on 'Cadastrar Ordem de Serviço'

    expect(page).to have_content 'Ordem de Serviço cadastrada com sucesso.'
    expect(page).to have_content('Código')
    expect(page).to have_content('Endereço de Retirada')
    expect(page).to have_content('Dimensões do Produto(C x L x A)')
    expect(page).to have_content('Peso do Produto')
    expect(page).to have_content('Endereço de Entrega')
    expect(page).to have_content('Cliente(CPF)')
    expect(page).to have_content('Distância de Entrega')
    expect(page).to have_content('ASDFGB456FGT7A7')
    expect(page).to have_content('Rua Baronesa, 10(60400-455)')
    expect(page).to have_content('100cm x 70cm x 80cm')
    expect(page).to have_content('12,40 kg')
    expect(page).to have_content('Rua Padre Filó, 24(60500-344)')
    expect(page).to have_content('Ana Paula Silva Oliveira(003.556.112-24)')
    expect(page).to have_content('70,5 km')
  end

  it 'com dados incompletos' do
    user = User.create(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :admin)
    allow(SecureRandom).to receive(:alphanumeric).and_return('ASDFGB456FGT7A7')

    login_as(user)
    visit root_path
    click_on 'Ordens de Serviço'
    click_on 'Cadastrar nova ordem de serviço'
    fill_in 'Endereço de Entrega', with: ''
    fill_in 'CEP da Entrega', with: ''
    fill_in 'Nome do Cliente', with: ''
    fill_in 'CPF do Cliente', with: ''
    fill_in 'Endereço de Retirada', with: ''
    fill_in 'CEP de Retirada', with: ''
    fill_in 'Distância de Entrega', with: ''
    fill_in 'Comprimento do Produto', with: ''
    fill_in 'Largura do Produto', with: ''
    fill_in 'Altura do Produto', with: ''
    fill_in 'Peso do Produto', with: ''
    click_on 'Cadastrar Ordem de Serviço'

    expect(page).to have_content 'Ordem de Serviço não cadastrada.'
    expect(page).to have_content('Largura do Produto não pode ficar em branco')
    expect(page).to have_content('Altura do Produto não pode ficar em branco')
    expect(page).to have_content('Peso do Produto não pode ficar em branco')
    expect(page).to have_content('Endereço de Retirada não pode ficar em branco')
    expect(page).to have_content('CEP de Retirada não pode ficar em branco')
    expect(page).to have_content('Distância de Entrega não pode ficar em branco')
    expect(page).to have_content('Endereço de Entrega não pode ficar em branco')
    expect(page).to have_content('CEP da Entrega não pode ficar em branco')
    expect(page).to have_content('Nome do Cliente não pode ficar em branco')
    expect(page).to have_content('CPF do Cliente não pode ficar em branco')
    expect(page).to have_content('Comprimento do Produto não pode ficar em branco')
  end
end
