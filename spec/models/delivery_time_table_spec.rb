require 'rails_helper'

RSpec.describe DeliveryTimeTable, type: :model do
  describe 'validações' do
    context 'quando end_range menor ou igual a start_range' do
      it 'é inválido' do
        transport_model = TransportModel.create(
          name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
          maximum_weight: 10_000, fixed_rate: 10, status: 'active'
        )
        delivery_time_index = DeliveryTimeTable.new(
          start_range: 60, end_range: 60,
          delivery_time: 5, transport_model:
        )

        expect(delivery_time_index).not_to be_valid
      end

      it 'adiciona erro' do
        transport_model = TransportModel.create(
          name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
          maximum_weight: 10_000, fixed_rate: 10, status: 'active'
        )
        delivery_time_index = DeliveryTimeTable.new(
          start_range: 60, end_range: 60,
          delivery_time: 5, transport_model:
        )

        delivery_time_index.validate

        expect(delivery_time_index.errors[:end_range]).to include "deve ser maior do que #{delivery_time_index.start_range}"
      end

      context 'quando start_range é diferente do end_range do intervalo anterior' do
        it 'é inválido' do
          transport_model = TransportModel.create(
            name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
            maximum_weight: 10_000, fixed_rate: 10, status: 'active'
          )
          _delivery_time_index_first = DeliveryTimeTable.create(
            start_range: 50, end_range: 60,
            delivery_time: 5, transport_model:
          )
          delivery_time_index_second = DeliveryTimeTable.new(
            start_range: 65, end_range: 70,
            delivery_time: 5, transport_model:
          )

          expect(delivery_time_index_second).not_to be_valid
        end

        it 'adiciona erro' do
          transport_model = TransportModel.create(
            name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
            maximum_weight: 10_000, fixed_rate: 10, status: 'active'
          )
          _delivery_time_index_first = DeliveryTimeTable.create(
            start_range: 50, end_range: 60,
            delivery_time: 5, transport_model:
          )
          delivery_time_index_second = DeliveryTimeTable.new(
            start_range: 65, end_range: 70,
            delivery_time: 5, transport_model:
          )

          delivery_time_index_second.validate

          expect(
            delivery_time_index_second.errors[:start_range]
          ).to include 'não pode ser diferente do valor da distância máxima do intervalo anterior ou menor que distância mínima da modalide de transporte'
        end
      end

      context 'quando start_range é o primeiro a ser cadastrado e menor que a distância mínima' do
        it 'é inválido' do
          transport_model = TransportModel.create(
            name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
            maximum_weight: 10_000, fixed_rate: 10, status: 'active'
          )
          delivery_time_index = DeliveryTimeTable.new(
            start_range: 40, end_range: 60,
            delivery_time: 5, transport_model:
          )

          expect(delivery_time_index).not_to be_valid
        end

        it 'adiciona erro' do
          transport_model = TransportModel.create(
            name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
            maximum_weight: 10_000, fixed_rate: 10, status: 'active'
          )
          delivery_time_index = DeliveryTimeTable.new(
            start_range: 40, end_range: 60,
            delivery_time: 5, transport_model:
          )

          delivery_time_index.validate

          expect(
            delivery_time_index.errors[:start_range]
          ).to include 'não pode ser diferente do valor da distância máxima do intervalo anterior ou menor que distância mínima da modalide de transporte'
        end
      end

      context 'quando start_range está dentro de outro range cadatrado' do
        it 'é inválido' do
          transport_model = TransportModel.create(
            name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
            maximum_weight: 10_000, fixed_rate: 10, status: 'active'
          )
          _delivery_time_index_first = DeliveryTimeTable.create!(
            start_range: 50, end_range: 70,
            delivery_time: 5, transport_model:
          )
          delivery_time_index_second = DeliveryTimeTable.new(
            start_range: 50, end_range: 65,
            delivery_time: 5, transport_model:
          )

          expect(delivery_time_index_second).not_to be_valid
        end

        it 'adiciona erro' do
          transport_model = TransportModel.create(
            name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
            maximum_weight: 10_000, fixed_rate: 10, status: 'active'
          )
          _delivery_time_index_first = DeliveryTimeTable.create(
            start_range: 50, end_range: 60,
            delivery_time: 5, transport_model:
          )
          delivery_time_index_second = DeliveryTimeTable.new(
            start_range: 55, end_range: 70,
            delivery_time: 5, transport_model:
          )

          delivery_time_index_second.validate

          expect(delivery_time_index_second.errors[:start_range]).to include 'não pode estar incluso entre intervalos já cadastrados'
        end
      end

      context 'quando end_range está dentro de outro range cadatrado' do
        it 'é inválido' do
          transport_model = TransportModel.create(
            name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
            maximum_weight: 10_000, fixed_rate: 10, status: 'active'
          )
          _delivery_time_index_first = DeliveryTimeTable.create!(
            start_range: 50, end_range: 60,
            delivery_time: 5, transport_model:
          )
          _delivery_time_index_second = DeliveryTimeTable.create!(
            start_range: 60, end_range: 70,
            delivery_time: 5, transport_model:
          )
          _delivery_time_index_third = DeliveryTimeTable.create!(
            start_range: 70, end_range: 80,
            delivery_time: 5, transport_model:
          )
          DeliveryTimeTable.find(2).destroy
          delivery_time_index_forth = DeliveryTimeTable.new(
            start_range: 60, end_range: 75,
            delivery_time: 5, transport_model:
          )

          expect(delivery_time_index_forth).not_to be_valid
        end

        it 'adiciona erro' do
          transport_model = TransportModel.create(
            name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
            maximum_weight: 10_000, fixed_rate: 10, status: 'active'
          )
          _delivery_time_index_first = DeliveryTimeTable.create!(
            start_range: 50, end_range: 60,
            delivery_time: 5, transport_model:
          )
          _delivery_time_index_second = DeliveryTimeTable.create!(
            start_range: 60, end_range: 70,
            delivery_time: 5, transport_model:
          )
          _delivery_time_index_third = DeliveryTimeTable.create!(
            start_range: 70, end_range: 80,
            delivery_time: 5, transport_model:
          )
          DeliveryTimeTable.find(2).destroy
          delivery_time_index_forth = DeliveryTimeTable.new(
            start_range: 60, end_range: 75,
            delivery_time: 5, transport_model:
          )

          delivery_time_index_forth.validate

          expect(delivery_time_index_forth.errors[:end_range]).to include 'não pode estar incluso entre intervalos já cadastrados'
        end

        context 'quando end_range é maior do que máxima distância da modalidade de transporte' do
          it 'é inválido' do
            transport_model = TransportModel.create(
              name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
              maximum_weight: 10_000, fixed_rate: 10, status: 'active'
            )
            _delivery_time_index_first = DeliveryTimeTable.create!(
              start_range: 50, end_range: 100,
              delivery_time: 5, transport_model:
            )
            delivery_time_index_second = DeliveryTimeTable.new(
              start_range: 100, end_range: 250,
              delivery_time: 5, transport_model:
            )

            expect(delivery_time_index_second).not_to be_valid
          end

          it 'adiciona erro' do
            transport_model = TransportModel.create(
              name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
              maximum_weight: 10_000, fixed_rate: 10, status: 'active'
            )
            _delivery_time_index_first = DeliveryTimeTable.create!(
              start_range: 50, end_range: 100,
              delivery_time: 5, transport_model:
            )
            delivery_time_index_second = DeliveryTimeTable.new(
              start_range: 100, end_range: 250,
              delivery_time: 5, transport_model:
            )

            delivery_time_index_second.validate

            expect(delivery_time_index_second.errors[:end_range]).to include 'não pode ser maior que máxima distância da modalidade de transporte'
          end
        end

        context 'quando prazo não foi preenchida' do
          it 'é inválido' do
            transport_model = TransportModel.create(
              name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
              maximum_weight: 10_000, fixed_rate: 10, status: 'active'
            )
            delivery_time_index = DeliveryTimeTable.new(
              start_range: 50, end_range: 150,
              delivery_time: '', transport_model:
            )

            expect(delivery_time_index).not_to be_valid
          end
        end

        context 'quando start_range não foi preenchida' do
          it 'é inválido' do
            transport_model = TransportModel.create(
              name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
              maximum_weight: 10_000, fixed_rate: 10, status: 'active'
            )
            delivery_time_index = DeliveryTimeTable.new(
              start_range: nil, end_range: 150,
              delivery_time: 5, transport_model:
            )

            expect(delivery_time_index).not_to be_valid
          end
        end

        context 'quando end_range não foi preenchida' do
          it 'é inválido' do
            transport_model = TransportModel.create(
              name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
              maximum_weight: 10_000, fixed_rate: 10, status: 'active'
            )
            delivery_time_index = DeliveryTimeTable.new(
              start_range: 50, end_range: nil,
              delivery_time: 5, transport_model:
            )

            expect(delivery_time_index).not_to be_valid
          end
        end

        context 'quando start_range não for único' do
          it 'é inválido' do
            transport_model = TransportModel.create(
              name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
              maximum_weight: 10_000, fixed_rate: 10, status: 'active'
            )
            _delivery_time_index_first = DeliveryTimeTable.create(
              start_range: 50, end_range: 60,
              delivery_time: 5, transport_model:
            )
            delivery_time_index_second = DeliveryTimeTable.new(
              start_range: 50, end_range: 70,
              delivery_time: 10, transport_model:
            )

            expect(delivery_time_index_second).not_to be_valid
          end
        end

        context 'quando end_range não for único' do
          it 'é inválido' do
            transport_model = TransportModel.create(
              name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
              maximum_weight: 10_000, fixed_rate: 10, status: 'active'
            )
            _delivery_time_index_first = DeliveryTimeTable.create!(
              start_range: 50, end_range: 60,
              delivery_time: 5, transport_model:
            )
            _price_by_distance_second = DeliveryTimeTable.create!(
              start_range: 60, end_range: 70,
              delivery_time: 5, transport_model:
            )
            _price_by_distance_third = DeliveryTimeTable.create!(
              start_range: 70, end_range: 80,
              delivery_time: 5, transport_model:
            )
            DeliveryTimeTable.find(2).destroy
            price_by_distance_forth = DeliveryTimeTable.new(
              start_range: 60, end_range: 80,
              delivery_time: 5, transport_model:
            )

            expect(price_by_distance_forth).not_to be_valid
          end
        end

        context 'quando delivery_time for negativa' do
          it 'é inválido' do
            transport_model = TransportModel.create(
              name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
              maximum_weight: 10_000, fixed_rate: 10, status: 'active'
            ) 
            delivery_time_index = DeliveryTimeTable.new(
              start_range: 50, end_range: 100,
              delivery_time: -5, transport_model:
            )

            expect(delivery_time_index).not_to be_valid
          end
        end
      end
    end
  end
end
