# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PriceByDistance, type: :model do
  describe 'validações' do
    context 'quando end_range menor ou igual a start_range' do
      it 'é inválido' do
        transport_model = TransportModel.create(
          name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
          maximum_weight: 10_000, fixed_rate: 10, status: 'active'
        )
        price_by_distance = PriceByDistance.new(
          start_range: 60, end_range: 60,
          distance_tax: 5, transport_model:
        )

        expect(price_by_distance).not_to be_valid
      end

      it 'adiciona erro' do
        transport_model = TransportModel.create(
          name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
          maximum_weight: 10_000, fixed_rate: 10, status: 'active'
        )
        price_by_distance = PriceByDistance.new(
          start_range: 60, end_range: 60,
          distance_tax: 5, transport_model:
        )

        price_by_distance.validate

        expect(price_by_distance.errors[:end_range]).to include "deve ser maior do que #{price_by_distance.start_range}"
      end

      context 'quando start_range é diferente do end_range do intervalo anterior' do
        it 'é inválido' do
          transport_model = TransportModel.create(
            name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
            maximum_weight: 10_000, fixed_rate: 10, status: 'active'
          )
          _price_by_distance_first = PriceByDistance.create(
            start_range: 50, end_range: 60,
            distance_tax: 5, transport_model:
          )
          price_by_distance_second = PriceByDistance.new(
            start_range: 65, end_range: 70,
            distance_tax: 5, transport_model:
          )

          expect(price_by_distance_second).not_to be_valid
        end

        it 'adiciona erro' do
          transport_model = TransportModel.create(
            name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
            maximum_weight: 10_000, fixed_rate: 10, status: 'active'
          )
          _price_by_distance_first = PriceByDistance.create(
            start_range: 50, end_range: 60,
            distance_tax: 5, transport_model:
          )
          price_by_distance_second = PriceByDistance.new(
            start_range: 65, end_range: 70,
            distance_tax: 5, transport_model:
          )

          price_by_distance_second.validate

          expect(
            price_by_distance_second.errors[:start_range]
          ).to include 'não pode ser diferente do valor da distância máxima do intervalo anterior ou menor que distância mínima da modalide de transporte'
        end
      end

      context 'quando start_range é o primeiro a ser cadastrado e menor que a distância mínima' do
        it 'é inválido' do
          transport_model = TransportModel.create(
            name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
            maximum_weight: 10_000, fixed_rate: 10, status: 'active'
          )
          price_by_distance = PriceByDistance.new(
            start_range: 40, end_range: 60,
            distance_tax: 5, transport_model:
          )

          expect(price_by_distance).not_to be_valid
        end

        it 'adiciona erro' do
          transport_model = TransportModel.create(
            name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
            maximum_weight: 10_000, fixed_rate: 10, status: 'active'
          )
          price_by_distance = PriceByDistance.new(
            start_range: 40, end_range: 60,
            distance_tax: 5, transport_model:
          )

          price_by_distance.validate

          expect(
            price_by_distance.errors[:start_range]
          ).to include 'não pode ser diferente do valor da distância máxima do intervalo anterior ou menor que distância mínima da modalide de transporte'
        end
      end

      context 'quando start_range está dentro de outro range cadatrado' do
        it 'é inválido' do
          transport_model = TransportModel.create(
            name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
            maximum_weight: 10_000, fixed_rate: 10, status: 'active'
          )
          _price_by_distance_first = PriceByDistance.create(
            start_range: 50, end_range: 70,
            distance_tax: 5, transport_model:
          )
          price_by_distance_second = PriceByDistance.new(
            start_range: 50, end_range: 65,
            distance_tax: 5, transport_model:
          )

          expect(price_by_distance_second).not_to be_valid
        end

        it 'adiciona erro' do
          transport_model = TransportModel.create(
            name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
            maximum_weight: 10_000, fixed_rate: 10, status: 'active'
          )
          _price_by_distance_first = PriceByDistance.create(
            start_range: 50, end_range: 60,
            distance_tax: 5, transport_model:
          )
          price_by_distance_second = PriceByDistance.new(
            start_range: 55, end_range: 70,
            distance_tax: 5, transport_model:
          )

          price_by_distance_second.validate

          expect(price_by_distance_second.errors[:start_range]).to include 'não pode estar incluso entre intervalos já cadastrados'
        end
      end

      context 'quando end_range está dentro de outro range cadatrado' do
        it 'é inválido' do
          transport_model = TransportModel.create(
            name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
            maximum_weight: 10_000, fixed_rate: 10, status: 'active'
          )
          _price_by_distance_first = PriceByDistance.create(
            start_range: 50, end_range: 60,
            distance_tax: 5, transport_model:
          )
          _price_by_distance_second = PriceByDistance.create(
            start_range: 60, end_range: 70,
            distance_tax: 5, transport_model:
          )
          _price_by_distance_third = PriceByDistance.create(
            start_range: 70, end_range: 80,
            distance_tax: 5, transport_model:
          )
          PriceByDistance.find(2).destroy
          price_by_distance_forth = PriceByDistance.new(
            start_range: 60, end_range: 75,
            distance_tax: 5, transport_model:
          )

          expect(price_by_distance_forth).not_to be_valid
        end

        it 'adiciona erro' do
          transport_model = TransportModel.create(
            name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
            maximum_weight: 10_000, fixed_rate: 10, status: 'active'
          )
          _price_by_distance_first = PriceByDistance.create(
            start_range: 50, end_range: 60,
            distance_tax: 5, transport_model:
          )
          _price_by_distance_second = PriceByDistance.create(
            start_range: 60, end_range: 70,
            distance_tax: 5, transport_model:
          )
          _price_by_distance_third = PriceByDistance.create(
            start_range: 70, end_range: 80,
            distance_tax: 5, transport_model:
          )
          PriceByDistance.find(2).destroy
          price_by_distance_forth = PriceByDistance.new(
            start_range: 60, end_range: 75,
            distance_tax: 5, transport_model:
          )

          price_by_distance_forth.validate

          expect(price_by_distance_forth.errors[:end_range]).to include 'não pode estar incluso entre intervalos já cadastrados'
        end

        context 'quando end_range é maior do que máxima distância da modalidade de transporte' do
          it 'é inválido' do
            transport_model = TransportModel.create(
              name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
              maximum_weight: 10_000, fixed_rate: 10, status: 'active'
            )
            _price_by_distance_first = PriceByDistance.create(
              start_range: 50, end_range: 100,
              distance_tax: 5, transport_model:
            )
            price_by_distance_second = PriceByDistance.new(
              start_range: 100, end_range: 250,
              distance_tax: 5, transport_model:
            )

            expect(price_by_distance_second).not_to be_valid
          end

          it 'adiciona erro' do
            transport_model = TransportModel.create(
              name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
              maximum_weight: 10_000, fixed_rate: 10, status: 'active'
            )
            _price_by_distance_first = PriceByDistance.create(
              start_range: 50, end_range: 100,
              distance_tax: 5, transport_model:
            )
            price_by_distance_second = PriceByDistance.new(
              start_range: 100, end_range: 250,
              distance_tax: 5, transport_model:
            )

            price_by_distance_second.validate

            expect(price_by_distance_second.errors[:end_range]).to include 'não pode ser maior que máxima distância da modalidade de transporte'
          end
        end

        context 'quando taxa não foi preenchida' do
          it 'é inválido' do
            transport_model = TransportModel.create(
              name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
              maximum_weight: 10_000, fixed_rate: 10, status: 'active'
            )
            price_by_distance = PriceByDistance.new(
              start_range: 50, end_range: 150,
              distance_tax: '', transport_model:
            )

            expect(price_by_distance).not_to be_valid
          end
        end

        context 'quando start_range não foi preenchida' do
          it 'é inválido' do
            transport_model = TransportModel.create(
              name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
              maximum_weight: 10_000, fixed_rate: 10, status: 'active'
            )
            price_by_distance = PriceByDistance.new(
              start_range: nil, end_range: 150,
              distance_tax: 5, transport_model:
            )

            expect(price_by_distance).not_to be_valid
          end
        end

        context 'quando end_range não foi preenchida' do
          it 'é inválido' do
            transport_model = TransportModel.create(
              name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
              maximum_weight: 10_000, fixed_rate: 10, status: 'active'
            )
            price_by_distance = PriceByDistance.new(
              start_range: 50, end_range: nil,
              distance_tax: 5, transport_model:
            )

            expect(price_by_distance).not_to be_valid
          end
        end

        context 'quando start_range não for único' do
          it 'é inválido' do
            transport_model = TransportModel.create(
              name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
              maximum_weight: 10_000, fixed_rate: 10, status: 'active'
            )
            _price_by_distance_first = PriceByDistance.create(
              start_range: 50, end_range: 60,
              distance_tax: 5, transport_model:
            )
            price_by_distance_second = PriceByDistance.new(
              start_range: 50, end_range: 70,
              distance_tax: 10, transport_model:
            )

            expect(price_by_distance_second).not_to be_valid
          end
        end

        context 'quando end_range não for único' do
          it 'é inválido' do
            transport_model = TransportModel.create(
              name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
              maximum_weight: 10_000, fixed_rate: 10, status: 'active'
            )
            _price_by_distance_first = PriceByDistance.create(
              start_range: 50, end_range: 60,
              distance_tax: 5, transport_model:
            )
            _price_by_distance_second = PriceByDistance.create(
              start_range: 60, end_range: 70,
              distance_tax: 5, transport_model:
            )
            _price_by_distance_third = PriceByDistance.create(
              start_range: 70, end_range: 80,
              distance_tax: 5, transport_model:
            )
            PriceByDistance.find(2).destroy
            price_by_distance_forth = PriceByDistance.new(
              start_range: 60, end_range: 80,
              distance_tax: 5, transport_model:
            )

            expect(price_by_distance_forth).not_to be_valid
          end
        end

        context 'quando distance_tax for negativa' do
          it 'é inválido' do
            transport_model = TransportModel.create(
              name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
              maximum_weight: 10_000, fixed_rate: 10, status: 'active'
            )
            price_by_distance = PriceByDistance.new(
              start_range: 50, end_range: 100,
              distance_tax: -5, transport_model:
            )

            expect(price_by_distance).not_to be_valid
          end
        end
      end
    end
  end
end
