require 'rails_helper'

RSpec.describe PriceByWeight, type: :model do
  describe 'validações' do
    context 'quando end_range menor ou igual a start_range' do
      it 'é inválido' do
        transport_model = TransportModel.create(
          name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
          maximum_weight: 10_000, fixed_rate: 10, status: 'active'
        )
        price_by_weight = PriceByWeight.new(
          start_range: 60, end_range: 60,
          price_for_kg: 5, transport_model:
        )

        expect(price_by_weight).not_to be_valid
      end

      it 'adiciona erro' do
        transport_model = TransportModel.create(
          name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
          maximum_weight: 10_000, fixed_rate: 10, status: 'active'
        )
        price_by_weight = PriceByWeight.new(
          start_range: 60, end_range: 60,
          price_for_kg: 5, transport_model:
        )

        price_by_weight.validate

        expect(price_by_weight.errors[:end_range]).to include "deve ser maior do que #{price_by_weight.start_range}"
      end

      context 'quando start_range é diferente do end_range do intervalo anterior' do
        it 'é inválido' do
          transport_model = TransportModel.create(
            name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
            maximum_weight: 10_000, fixed_rate: 10, status: 'active'
          )
          _prices_by_weight_first = PriceByWeight.create(
            start_range: 50, end_range: 60,
            price_for_kg: 5, transport_model:
          )
          prices_by_weight_second = PriceByWeight.new(
            start_range: 65, end_range: 70,
            price_for_kg: 5, transport_model:
          )

          expect(prices_by_weight_second).not_to be_valid
        end

        it 'adiciona erro' do
          transport_model = TransportModel.create(
            name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
            maximum_weight: 10_000, fixed_rate: 10, status: 'active'
          )
          _prices_by_weight_first = PriceByWeight.create(
            start_range: 50, end_range: 60,
            price_for_kg: 5, transport_model:
          )
          prices_by_weight_second = PriceByWeight.new(
            start_range: 65, end_range: 70,
            price_for_kg: 5, transport_model:
          )

          prices_by_weight_second.validate

          expect(
            prices_by_weight_second.errors[:start_range]
          ).to include 'não pode ser diferente do valor do peso máximo do intervalo anterior ou menor que o peso mínimo da modalide de transporte'
        end
      end

      context 'quando start_range é o primeiro a ser cadastrado e menor que o peso mínimo' do
        it 'é inválido' do
          transport_model = TransportModel.create(
            name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
            maximum_weight: 10_000, fixed_rate: 10, status: 'active'
          )
          price_by_weight = PriceByWeight.new(
            start_range: 40, end_range: 60,
            price_for_kg: 5, transport_model:
          )

          expect(price_by_weight).not_to be_valid
        end

        it 'adiciona erro' do
          transport_model = TransportModel.create(
            name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
            maximum_weight: 10_000, fixed_rate: 10, status: 'active'
          )
          price_by_weight = PriceByWeight.new(
            start_range: 40, end_range: 60,
            price_for_kg: 5, transport_model:
          )

          price_by_weight.validate

          expect(
            price_by_weight.errors[:start_range]
          ).to include 'não pode ser diferente do valor do peso máximo do intervalo anterior ou menor que o peso mínimo da modalide de transporte'
        end
      end

      context 'quando start_range está dentro de outro range cadastrado' do
        it 'é inválido' do
          transport_model = TransportModel.create(
            name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
            maximum_weight: 10_000, fixed_rate: 10, status: 'active'
          )
          _prices_by_weight_first = PriceByWeight.create!(
            start_range: 10, end_range: 70,
            price_for_kg: 5, transport_model:
          )
          prices_by_weight_second = PriceByWeight.new(
            start_range: 50, end_range: 80,
            price_for_kg: 5, transport_model:
          )

          expect(prices_by_weight_second).not_to be_valid
        end

        it 'adiciona erro' do
          transport_model = TransportModel.create(
            name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
            maximum_weight: 10_000, fixed_rate: 10, status: 'active'
          )
          _prices_by_weight_first = PriceByWeight.create(
            start_range: 10, end_range: 60,
            price_for_kg: 5, transport_model:
          )
          prices_by_weight_second = PriceByWeight.new(
            start_range: 55, end_range: 70,
            price_for_kg: 5, transport_model:
          )

          prices_by_weight_second.validate

          expect(prices_by_weight_second.errors[:start_range]).to include 'não pode estar incluso entre intervalos já cadastrados'
        end
      end

      context 'quando end_range está dentro de outro range cadastrado' do
        it 'é inválido' do
          transport_model = TransportModel.create(
            name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
            maximum_weight: 10_000, fixed_rate: 10, status: 'active'
          )
          _prices_by_weight_first = PriceByWeight.create!(
            start_range: 10, end_range: 60,
            price_for_kg: 5, transport_model:
          )
          _price_by_weight_second = PriceByWeight.create!(
            start_range: 60, end_range: 70,
            price_for_kg: 5, transport_model:
          )
          _price_by_weight_third = PriceByWeight.create!(
            start_range: 70, end_range: 80,
            price_for_kg: 5, transport_model:
          )
          PriceByWeight.find(2).destroy
          prices_by_weight_forth = PriceByWeight.new(
            start_range: 60, end_range: 75,
            price_for_kg: 5, transport_model:
          )

          expect(prices_by_weight_forth).not_to be_valid
        end

        it 'adiciona erro' do
          transport_model = TransportModel.create(
            name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
            maximum_weight: 10_000, fixed_rate: 10, status: 'active'
          )
          _prices_by_weight_first = PriceByWeight.create!(
            start_range: 10, end_range: 60,
            price_for_kg: 5, transport_model:
          )
          _price_by_weight_second = PriceByWeight.create!(
            start_range: 60, end_range: 70,
            price_for_kg: 5, transport_model:
          )
          _price_by_weight_third = PriceByWeight.create!(
            start_range: 70, end_range: 80,
            price_for_kg: 5, transport_model:
          )
          PriceByWeight.find(2).destroy
          prices_by_weight_forth = PriceByWeight.new(
            start_range: 60, end_range: 75,
            price_for_kg: 5, transport_model:
          )

          prices_by_weight_forth.validate

          expect(prices_by_weight_forth.errors[:end_range]).to include 'não pode estar incluso entre intervalos já cadastrados'
        end

        context 'quando end_range é maior do que o peso máximo da modalidade de transporte' do
          it 'é inválido' do
            transport_model = TransportModel.create(
              name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
              maximum_weight: 10_000, fixed_rate: 10, status: 'active'
            )
            _prices_by_weight_first = PriceByWeight.create!(
              start_range: 10, end_range: 1000,
              price_for_kg: 5, transport_model:
            )
            prices_by_weight_second = PriceByWeight.new(
              start_range: 1000, end_range: 20_000,
              price_for_kg: 5, transport_model:
            )

            expect(prices_by_weight_second).not_to be_valid
          end

          it 'adiciona erro' do
            transport_model = TransportModel.create(
              name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
              maximum_weight: 10_000, fixed_rate: 10, status: 'active'
            )
            _prices_by_weight_first = PriceByWeight.create!(
              start_range: 10, end_range: 1000,
              price_for_kg: 5, transport_model:
            )
            prices_by_weight_second = PriceByWeight.new(
              start_range: 1000, end_range: 20_000,
              price_for_kg: 5, transport_model:
            )

            prices_by_weight_second.validate

            expect(prices_by_weight_second.errors[:end_range]).to include 'não pode ser maior que o peso máximo da modalidade de transporte'
          end
        end

        context 'quando taxa não foi preenchida' do
          it 'é inválido' do
            transport_model = TransportModel.create(
              name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
              maximum_weight: 10_000, fixed_rate: 10, status: 'active'
            )
            prices_by_weight_second = PriceByWeight.new(
              start_range: 50, end_range: 150,
              price_for_kg: '', transport_model:
            )

            expect(prices_by_weight_second).not_to be_valid
          end
        end

        context 'quando start_range não foi preenchida' do
          it 'é inválido' do
            transport_model = TransportModel.create(
              name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
              maximum_weight: 10_000, fixed_rate: 10, status: 'active'
            )
            prices_by_weight = PriceByWeight.new(
              start_range: nil, end_range: 150,
              price_for_kg: 5, transport_model:
            )

            expect(prices_by_weight).not_to be_valid
          end
        end

        context 'quando end_range não foi preenchida' do
          it 'é inválido' do
            transport_model = TransportModel.create(
              name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
              maximum_weight: 10_000, fixed_rate: 10, status: 'active'
            )
            prices_by_weight = PriceByWeight.new(
              start_range: 50, end_range: nil,
              price_for_kg: 5, transport_model:
            )

            expect(prices_by_weight).not_to be_valid
          end
        end

        context 'quando start_range não for único' do
          it 'é inválido' do
            transport_model = TransportModel.create(
              name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
              maximum_weight: 10_000, fixed_rate: 10, status: 'active'
            )
            _prices_by_weight_first = PriceByWeight.create(
              start_range: 50, end_range: 60,
              price_for_kg: 5, transport_model:
            )
            prices_by_weight_second = PriceByWeight.new(
              start_range: 50, end_range: 70,
              price_for_kg: 10, transport_model:
            )

            expect(prices_by_weight_second).not_to be_valid
          end
        end

        context 'quando end_range não for único' do
          it 'é inválido' do
            transport_model = TransportModel.create(
              name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
              maximum_weight: 10_000, fixed_rate: 10, status: 'active'
            )
            _prices_by_weight_first = PriceByWeight.create!(
              start_range: 10, end_range: 60,
              price_for_kg: 5, transport_model:
            )
            _price_by_weight_second = PriceByWeight.create!(
              start_range: 60, end_range: 70,
              price_for_kg: 5, transport_model:
            )
            _price_by_weight_third = PriceByWeight.create!(
              start_range: 70, end_range: 80,
              price_for_kg: 5, transport_model:
            )
            PriceByWeight.find(2).destroy
            prices_by_weight_forth = PriceByWeight.new(
              start_range: 60, end_range: 80,
              price_for_kg: 5, transport_model:
            )

            expect(prices_by_weight_forth).not_to be_valid
          end
        end

        context 'quando price_for_kg for negativo' do
          it 'é inválido' do
            transport_model = TransportModel.create(
              name: 'Sedex', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
              maximum_weight: 10_000, fixed_rate: 10, status: 'active'
            )
            price_by_weight = PriceByWeight.new(
              start_range: 50, end_range: 100,
              price_for_kg: -5, transport_model:
            )

            expect(price_by_weight).not_to be_valid
          end
        end
      end
    end
  end
end
