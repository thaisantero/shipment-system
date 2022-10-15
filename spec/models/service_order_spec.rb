require 'rails_helper'

RSpec.describe ServiceOrder, type: :model do
  describe 'validação' do
    it 'presençao do código gerado' do
      customer = Customer.create!(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
                                  customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')
      service_order = ServiceOrder.create!(pickup_address: 'Rua Baronesa, 10', pickup_cep: '60400455', customer: customer,
                                           delivery_distance: 70.5)

      code = service_order.code

      expect(code).not_to be_empty
      expect(code.length).to eq 15
    end

    it 'presençao do pickup_adress' do
      customer = Customer.create!(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
                                  customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')
      service_order = ServiceOrder.create(pickup_address: nil, pickup_cep: '60400455', customer: customer,
                                           delivery_distance: 70.5)

      expect(service_order).not_to be_valid
    end

    it 'presençao do pickup_cep' do
      customer = Customer.create!(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
                                  customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')
      service_order = ServiceOrder.create(pickup_address: 'Rua Baronesa, 10', pickup_cep: nil, customer: customer,
                                           delivery_distance: 70.5)

      expect(service_order).not_to be_valid
    end

    it 'presençao do delivery_distance' do
      customer = Customer.create!(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
                                  customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')
      service_order = ServiceOrder.create(pickup_address: 'Rua Baronesa, 10', pickup_cep: '60400455', customer: customer,
                                           delivery_distance: nil)

      expect(service_order).not_to be_valid
    end

    it 'delivery_distance maior que zero' do
      customer = Customer.create!(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
                                  customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')
      service_order = ServiceOrder.create(pickup_address: 'Rua Baronesa, 10', pickup_cep: '60400455', customer: customer,
                                           delivery_distance: -10)

      expect(service_order).not_to be_valid
    end

    it 'código é único' do
      customer = Customer.create!(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
                                  customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')
      service_order_first = ServiceOrder.create(pickup_address: 'Rua Baronesa, 10', pickup_cep: '60400455', customer: customer,
                                           delivery_distance: 10)
      service_order_second = ServiceOrder.create(pickup_address: 'Rua General, 20', pickup_cep: '60400855', customer: customer,
                                                delivery_distance: 20)

      expect(service_order_second.code).not_to eq service_order_first.code
    end

    it 'cep tem 8 dígitos' do
      customer = Customer.create!(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
                                  customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')
      service_order = ServiceOrder.create(pickup_address: 'Rua Baronesa, 10', pickup_cep: '604004552', customer: customer,
                                           delivery_distance: 10)

      expect(service_order).not_to be_valid
    end

    it 'cep só tem números' do
      customer = Customer.create!(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
                                  customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')
      service_order = ServiceOrder.create(pickup_address: 'Rua Baronesa, 10', pickup_cep: '6040045A', customer: customer,
                                           delivery_distance: 10)

      expect(service_order).not_to be_valid
    end

    it 'delivery_description obrigatório quando entrega atrasada' do
      customer = Customer.create!(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
                                  customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')
      service_order = ServiceOrder.new(pickup_address: 'Rua Baronesa, 10', pickup_cep: '60400454', customer: customer,
                                       delivery_distance: 10, delivery_status: :with_delay)

      expect(service_order).not_to be_valid
    end

    it 'delivery_description não é obrigatório quando entrega sem atraso' do
      customer = Customer.create!(customer_address: 'Rua Padre Filó, 24', customer_cep: '60500344',
                                  customer_name: 'Ana Paula Silva Oliveira', customer_registration_number: '00355611224')
      service_order = ServiceOrder.new(pickup_address: 'Rua Baronesa, 10', pickup_cep: '60400454', customer: customer,
                                       delivery_distance: 10, delivery_status: :on_time)

      expect(service_order).to be_valid
    end
  end
end
