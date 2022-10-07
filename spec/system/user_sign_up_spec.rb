require 'rails_helper'

describe 'Usuário se cadastra' do
  it 'com sucesso' do
    visit root_path
    click_on 'Entrar'
    click_on 'Criar uma conta'
    within('form') do
      fill_in 'Nome', with: 'User'
      fill_in 'E-mail', with: 'user@sistemadefrete.com.br'
      fill_in 'Senha', with: 'password'
      fill_in 'Confirme sua senha', with: 'password'
      click_on 'Criar conta'
    end

    expect(page).to have_content 'Você realizou seu registro com sucesso.'
    within('nav') do
      expect(page).to have_content 'User | user@sistemadefrete.com.br | Usuário Regular'
      expect(page).not_to have_content 'User | user@sistemadefrete.com.br | Administrador(a)'
      expect(page).to have_button 'Sair'
    end
  end

  it 'com dados imcompletos' do
    visit root_path
    click_on 'Entrar'
    click_on 'Criar uma conta'
    within('form') do
      fill_in 'Nome', with: ''
      fill_in 'E-mail', with: ''
      fill_in 'Senha', with: ''
      click_on 'Criar conta'
    end

    expect(page).to have_content 'E-mail não pode ficar em branco'
    expect(page).to have_content 'Senha não pode ficar em branco'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_link 'Entrar'
  end
end
