require 'rails_helper'

describe 'Usuário vê ordens de serviço pendentes' do
  it 'sendo usuário regular' do
    user = User.create!(name: 'User', email: 'user@sistemadefrete.com.br', password: 'password', role: :regular_user)
    customer = Customer.create!(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
      customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')
    allow(SecureRandom).to receive(:alphanumeric).and_return('ASDFGB456FGT7A7')
    service_order = ServiceOrder.create!(pickup_address: 'Rua Baronesa, 10', pickup_cep: '60400455', customer: customer,
                  delivery_distance: 70.5)
    Product.create!(length: 100, width: 70, height: 80, weight: 12.4, service_order: service_order)

    login_as(user)
    visit root_path
    click_on 'Ordens de Serviço'
    click_on 'Pendentes'

    expect(page).not_to have_content('Nao existem ordens de serviço cadastradas')
    expect(page).to have_content('Código')
    expect(page).to have_content('Endereço de Entrega')
    expect(page).to have_content('Distância de Entrega')
    expect(page).to have_content('ASDFGB456FGT7A7')
    expect(page).to have_content('Rua Padre Filó, 24(60500-344)')
    expect(page).to have_content('70,5 km')
  end
end
