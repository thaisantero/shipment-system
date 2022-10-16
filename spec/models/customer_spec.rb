# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'validações' do
    context 'quando customer_address não foi preenchido' do
      it 'é inválido' do
        customer = Customer.create(customer_address: nil, customer_cep: '60500344',
                                   customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')

        expect(customer).not_to be_valid
      end
    end

    context 'quando customer_cep não foi preenchido' do
      it 'é inválido' do
        customer = Customer.create(customer_address: 'Rua Padre Filó, 24', customer_cep: nil,
                                   customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')

        expect(customer).not_to be_valid
      end
    end

    context 'quando customer_name não foi preenchido' do
      it 'é inválido' do
        customer = Customer.create(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
                                   customer_name: nil, customer_registration_number: '00355611224')

        expect(customer).not_to be_valid
      end
    end

    context 'quando customer_registration_number não foi preenchido' do
      it 'é inválido' do
        customer = Customer.create(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
                                   customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: nil)

        expect(customer).not_to be_valid
      end
    end

    context 'quando customer_registration_number não tem 11 dígitos' do
      it 'é inválido' do
        customer = Customer.create(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
                                   customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '1234567')

        expect(customer).not_to be_valid
      end
    end

    context 'quando customer_cep não tem 8 dígitos' do
      it 'é inválido' do
        customer = Customer.create(customer_address: 'Rua Padre Filó, 24', customer_cep: '6050034409',
                                   customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')

        expect(customer).not_to be_valid
      end
    end

    context 'quando customer_registration_number não tem somente números' do
      it 'é inválido' do
        customer = Customer.create(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
                                   customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '0035561122A')

        expect(customer).not_to be_valid
      end
    end

    context 'quando customer_cep não tem somente números' do
      it 'é inválido' do
        customer = Customer.create(customer_address: 'Rua Padre Filó, 24', customer_cep: '605003440B',
                                   customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')

        expect(customer).not_to be_valid
      end
    end

    context 'quando customer_registration_number não é único' do
      it 'é inválido' do
        _customer_first = Customer.create(customer_address: 'Rua Padre Filó, 45', customer_cep: '60500344',
                                          customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')
        customer_second = Customer.create(customer_address: 'Rua Padre Valdavino, 24', customer_cep: '60564534',
                                          customer_name: 'Matheus Silva Oliveira', customer_registration_number: '00355611224')

        expect(customer_second).not_to be_valid
      end
    end
  end
end
