require 'rails_helper'

describe 'Usuário vê ordens de serviço cadastradas' do
  it 'se estiver autenticado' do
    visit root_path
    click_on 'Ordens de Serviço'

    expect(current_path).to eq new_user_session_path
  end

  it 'sendo usuário regular' do
    user = User.create!(name: 'User', email: 'user@sistemadefrete.com.br', password: 'password', role: :regular_user)
    customer = Customer.create!(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
                                customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')
    service_order = ServiceOrder.create!(pickup_address: 'Rua Baronesa, 10', pickup_cep: '60400455', customer: customer,
                                         delivery_distance: 70.5)
    Product.create!(length: 100, width: 70, height: 80, weight: 12.4, service_order: service_order)

    login_as(user)
    visit root_path
    click_on 'Ordens de Serviço'

    expect(page).not_to have_content('Nao existem ordens de serviço cadastradas')

    expect(page).to have_content('Endereço de Retirada')
    expect(page).to have_content('Dimensões do Produto(C x L x A)')
    expect(page).to have_content('Peso do Produto')
    expect(page).to have_content('Endereço de Entrega')
    expect(page).to have_content('Cliente (CPF)')
    expect(page).to have_content('Distância de Entrega')
    expect(page).to have_content('Rua Baronesa, 10(60400-455)')
    expect(page).to have_content('100cm x 70cm x 80cm')
    expect(page).to have_content('12,40 kg')
    expect(page).to have_content('Rua Padre Filó, 24(60500-344)')
    expect(page).to have_content('Ana Paula Silva Oliveira(003.556.112-24)')
    expect(page).to have_content('70,5 km')
  end

  it 'sendo administrador' do
    user = User.create!(name: 'User', email: 'user@sistemadefrete.com.br', password: 'password', role: :admin)
    customer = Customer.create!(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
                                customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')
    service_order = ServiceOrder.create!(pickup_address: 'Rua Baronesa, 10', pickup_cep: '60400455', customer: customer,
                                         delivery_distance: 70.5)
    Product.create!(length: 100, width: 70, height: 80, weight: 12.4, service_order: service_order)

    login_as(user)
    visit root_path
    click_on 'Ordens de Serviço'

    expect(page).not_to have_content('Nao existem ordens de serviço cadastradas')

    expect(page).to have_content('Endereço de Retirada')
    expect(page).to have_content('Dimensões do Produto(C x L x A)')
    expect(page).to have_content('Peso do Produto')
    expect(page).to have_content('Endereço de Entrega')
    expect(page).to have_content('Cliente (CPF)')
    expect(page).to have_content('Distância de Entrega')
    expect(page).to have_content('Rua Baronesa, 10(60400-455)')
    expect(page).to have_content('100cm x 70cm x 80cm')
    expect(page).to have_content('12,40 kg')
    expect(page).to have_content('Rua Padre Filó, 24(60500-344)')
    expect(page).to have_content('Ana Paula Silva Oliveira(003.556.112-24)')
    expect(page).to have_content('70,5 km')
  end
end
