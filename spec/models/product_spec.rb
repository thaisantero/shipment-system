require 'rails_helper'

RSpec.describe Product, type: :model do\
  describe 'validações' do
    context 'quando length não foi preenchido' do
      it 'é inválido' do
        customer = Customer.create!(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
                                    customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')
        service_order = ServiceOrder.create!(pickup_address: 'Rua Baronesa, 10', pickup_cep: '60400455', customer: customer,
                                             delivery_distance: 70.5)
        product = Product.create(length: nil, width: 70, height: 80, weight: 12.4, service_order: service_order)

        expect(product).not_to be_valid
      end
    end

    context 'quando width não foi preenchido' do
      it 'é inválido' do
        customer = Customer.create!(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
                                    customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')
        service_order = ServiceOrder.create!(pickup_address: 'Rua Baronesa, 10', pickup_cep: '60400455', customer: customer,
                                             delivery_distance: 70.5)
        product = Product.create(length: 100, width: nil, height: 80, weight: 12.4, service_order: service_order)

        expect(product).not_to be_valid
      end
    end

    context 'quando height não foi preenchido' do
      it 'é inválido' do
        customer = Customer.create!(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
                                    customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')
        service_order = ServiceOrder.create!(pickup_address: 'Rua Baronesa, 10', pickup_cep: '60400455', customer: customer,
                                             delivery_distance: 70.5)
        product = Product.create(length: 100, width: 70, height: nil, weight: 12.4, service_order: service_order)

        expect(product).not_to be_valid
      end
    end

    context 'quando weight não foi preenchido' do
      it 'é inválido' do
        customer = Customer.create!(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
                                    customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')
        service_order = ServiceOrder.create!(pickup_address: 'Rua Baronesa, 10', pickup_cep: '60400455', customer: customer,
                                             delivery_distance: 70.5)
        product = Product.create(length: 100, width: 70, height: 80, weight: nil, service_order: service_order)

        expect(product).not_to be_valid
      end
    end

    context 'quando length é negativo' do
      it 'é inválido' do
        customer = Customer.create!(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
                                    customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')
        service_order = ServiceOrder.create!(pickup_address: 'Rua Baronesa, 10', pickup_cep: '60400455', customer: customer,
                                             delivery_distance: 70.5)
        product = Product.create(length: -100, width: 70, height: 80, weight: 12.4, service_order: service_order)

        expect(product).not_to be_valid
      end
    end

    context 'quando width é negativo' do
      it 'é inválido' do
        customer = Customer.create!(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
                                    customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')
        service_order = ServiceOrder.create!(pickup_address: 'Rua Baronesa, 10', pickup_cep: '60400455', customer: customer,
                                             delivery_distance: 70.5)
        product = Product.create(length: 100, width: -80, height: 80, weight: 12.4, service_order: service_order)

        expect(product).not_to be_valid
      end
    end

    context 'quando height é negativo' do
      it 'é inválido' do
        customer = Customer.create!(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
                                    customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')
        service_order = ServiceOrder.create!(pickup_address: 'Rua Baronesa, 10', pickup_cep: '60400455', customer: customer,
                                             delivery_distance: 70.5)
        product = Product.create(length: 100, width: 70, height: -90, weight: 12.4, service_order: service_order)

        expect(product).not_to be_valid
      end
    end

    context 'quando weight não é negativo' do
      it 'é inválido' do
        customer = Customer.create!(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
                                    customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')
        service_order = ServiceOrder.create!(pickup_address: 'Rua Baronesa, 10', pickup_cep: '60400455', customer: customer,
                                             delivery_distance: 70.5)
        product = Product.create(length: 100, width: 70, height: 80, weight: -70, service_order: service_order)

        expect(product).not_to be_valid
      end
    end
  end
end
