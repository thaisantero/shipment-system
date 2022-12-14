# frozen_string_literal: true

require 'rails_helper'

describe 'Usuário se autentica' do
  it 'com sucesso' do
    User.create(name: 'User', email: 'user@sistemadefrete.com.br', password: 'password')

    visit root_path
    click_on 'Entrar'
    within('form') do
      fill_in 'E-mail', with: 'user@sistemadefrete.com.br'
      fill_in 'Senha', with: 'password'
      click_on 'Entrar'
    end

    expect(page).to have_content 'Login efetuado com sucesso.'
    expect(page).to have_button 'Sair'
    expect(page).not_to have_link 'Entrar'
    within('nav') do
      expect(page).to have_content 'User | user@sistemadefrete.com.br Usuário Regular'
      expect(page).not_to have_content 'User | user@sistemadefrete.com.br Administrador(a)'
    end
  end

  it 'e faz logout' do
    User.create(name: 'User', email: 'user@sistemadefrete.com.br', password: 'password')

    visit root_path
    click_on 'Entrar'
    within('form') do
      fill_in 'E-mail', with: 'user@sistemadefrete.com.br'
      fill_in 'Senha', with: 'password'
      click_on 'Entrar'
    end
    click_on 'Sair'

    expect(page).to have_content 'Logout efetuado com sucesso.'
    expect(page).to have_link 'Entrar'
    expect(page).not_to have_button 'Sair'
    expect(page).not_to have_content 'User'
  end
end
