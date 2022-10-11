require 'rails_helper'

describe 'Usuário edita um modelo de transporte' do
  it 'se for administrador' do
    user = User.create!(name: 'User', email: 'user@sistemadefrete.com.br', password: 'password', role: :regular_user)
    TransportModel.create(name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
                          maximum_weight: 10_000, fixed_rate: 10)

    # Act
    login_as(user)
    visit root_path
    click_on 'Modelos de Transporte'

    expect(current_path).to eq transport_models_path
    expect(page).not_to have_link('Editar')
  end

  it 'visualizando dados cadastrados' do
    user = User.create!(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :admin)
    TransportModel.create(name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
                          maximum_weight: 10_000, fixed_rate: 10)

    login_as(user)
    visit root_path
    click_on 'Modelos de Transporte'
    click_on 'Editar'

    expect(page).to have_content('Editar Modelo de Transporte')
    expect(page).to have_field('Nome', with: 'Express')
    expect(page).to have_field('Distância Mínima', with: 50)
    expect(page).to have_field('Distância Máxima', with: 200)
    expect(page).to have_field('Peso Mínimo', with: 10)
    expect(page).to have_field('Peso Máximo', with: 10000)
    expect(page).to have_field('Taxa Fixa', with: 10)
  end

  it 'com sucesso' do
    user = User.create!(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :admin)
    TransportModel.create!(
      name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
      maximum_weight: 10_000, fixed_rate: 10
    )

    login_as(user)
    visit root_path
    click_on 'Modelos de Transporte'
    click_on 'Editar'
    fill_in 'Nome', with: 'Sedex'
    fill_in 'Distância Mínima', with: 100
    fill_in 'Distância Máxima', with: 400
    click_on 'Cadastrar'

    expect(page).to have_content('Modelo de Transporte atualizado com sucesso.')
    expect(page).to have_content('Sedex')
    expect(page).to have_content('100 - 400km')
  end

  it 'e mantém os campos obrigatórios' do
    user = User.create!(name: 'Joao', email: 'joao@sistemadefrete.com.br', password: 'password', role: :admin)
    TransportModel.create(name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
                          maximum_weight: 10_000, fixed_rate: 10)

    login_as(user)
    visit root_path
    click_on 'Modelos de Transporte'
    click_on 'Editar'
    fill_in 'Nome', with: ''
    fill_in 'Distância Mínima', with: ''
    fill_in 'Distância Máxima', with: ''
    click_on 'Cadastrar'

    expect(page).to have_content('Não foi possível atualizar o modelo de transporte')
  end
end
