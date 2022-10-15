require 'rails_helper'

RSpec.describe TransportModel, type: :model do
  describe 'válido?' do
    context 'presença' do
      it 'falso quando name está vazio' do
        transport_model = TransportModel.create(
          name: '', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
          maximum_weight: 10_000, fixed_rate: 10, status: 'active'
        )

        expect(transport_model).not_to be_valid
      end

      it 'falso quando distância mínima está vazia' do
        transport_model = TransportModel.create(
          name: 'Express', minimum_distance: '', maximum_distance: 200, minimum_weight: 10,
          maximum_weight: 10_000, fixed_rate: 10, status: 'active'
        )

        expect(transport_model).not_to be_valid
      end

      it 'falso quando distância máxima está vazia' do
        transport_model = TransportModel.create(
          name: 'Express', minimum_distance: 50, maximum_distance: '', minimum_weight: 10,
          maximum_weight: 10_000, fixed_rate: 10, status: 'active'
        )

        expect(transport_model).not_to be_valid
      end

      it 'falso quando peso mínimo está vazio' do
        transport_model = TransportModel.create(
          name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: nil,
          maximum_weight: 10_000, fixed_rate: 10, status: 'active'
        )

        expect(transport_model).not_to be_valid
      end

      it 'falso quando peso máximo está vazio' do
        transport_model = TransportModel.create(
          name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
          maximum_weight: nil, fixed_rate: 10, status: 'active'
        )

        expect(transport_model).not_to be_valid
      end

      it 'falso quando taxa fixa está vazia' do
        transport_model = TransportModel.create(
          name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
          maximum_weight: 10_000, fixed_rate: '', status: 'active'
        )

        expect(transport_model).not_to be_valid
      end
    end

    context 'valores negativos' do
      it 'distância mínima menor que zero' do
        transport_model = TransportModel.create(
          name: 'Express', minimum_distance: -50, maximum_distance: 200, minimum_weight: 10,
          maximum_weight: 10_000, fixed_rate: 10, status: 'active'
        )

        expect(transport_model).not_to be_valid
      end

      it 'distância máxima menor que zero' do
        transport_model = TransportModel.create(
          name: 'Express', minimum_distance: 50, maximum_distance: -200, minimum_weight: 10,
          maximum_weight: 10_000, fixed_rate: 10, status: 'active'
        )

        expect(transport_model).not_to be_valid
      end

      it 'peso mínimo menor que zero' do
        transport_model = TransportModel.create(
          name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: -10,
          maximum_weight: 10_000, fixed_rate: 10, status: 'active'
        )

        expect(transport_model).not_to be_valid
      end

      it 'peso máximo menor que zero' do
        transport_model = TransportModel.create(
          name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
          maximum_weight: -10_000, fixed_rate: 10, status: 'active'
        )

        expect(transport_model).not_to be_valid
      end

      it 'taxa fixa menor que zero' do
        transport_model = TransportModel.create(
          name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
          maximum_weight: 10_000, fixed_rate: -10, status: 'active'
        )

        expect(transport_model).not_to be_valid
      end
    end
  end

  describe '#tax_distance' do
    it 'retorna taxa por distância' do
      transport_model = TransportModel.create(
        name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
        maximum_weight: 10_000, fixed_rate: 10, status: 'active'
      )

      price_by_distance_first = PriceByDistance.create(
        start_range: 50, end_range: 60,
        distance_tax: 5, transport_model:
      )
      price_by_distance_second = PriceByDistance.create(
        start_range: 60, end_range: 70,
        distance_tax: 10, transport_model:
      )
      distance = 65

      expect(transport_model.tax_distance(distance)).to eq price_by_distance_second.distance_tax
    end

    it 'retorna zero quando distância não está contida em nenhum intervalo' do
      transport_model = TransportModel.create(
        name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
        maximum_weight: 10_000, fixed_rate: 10, status: 'active'
      )

      price_by_distance_first = PriceByDistance.create(
        start_range: 50, end_range: 60,
        distance_tax: 5, transport_model:
      )
      price_by_distance_second = PriceByDistance.create(
        start_range: 60, end_range: 70,
        distance_tax: 10, transport_model:
      )
      distance = 80

      expect(transport_model.tax_distance(distance)).to eq 0
    end
  end

  describe '#tax_weight' do
    it 'retorna taxa por peso (preço por peso x distância)' do
      transport_model = TransportModel.create!(
        name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
        maximum_weight: 10_000, fixed_rate: 10, status: 'active'
      )

      prices_by_weight_first = PriceByWeight.create!(
        start_range: 10, end_range: 50,
        price_for_kg: 5, transport_model: transport_model
      )
      prices_by_weight_second = PriceByWeight.create!(
        start_range: 50, end_range: 100,
        price_for_kg: 10, transport_model: transport_model
      )
      weight = 65
      distance = 100
      result = prices_by_weight_second.price_for_kg * distance

      expect(transport_model.tax_weight(weight, distance)).to eq result
    end

    it 'retorna zero quando peso não está contido em nenhum intervalo' do
      transport_model = TransportModel.create(
        name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
        maximum_weight: 10_000, fixed_rate: 10, status: 'active'
      )

      prices_by_weight_first = PriceByWeight.create(
        start_range: 50, end_range: 60,
        price_for_kg: 5, transport_model:
      )
      prices_by_weight_second = PriceByWeight.create(
        start_range: 60, end_range: 70,
        price_for_kg: 10, transport_model:
      )
      weight = 80
      distance = 100

      expect(transport_model.tax_weight(weight, distance)).to eq 0
    end
  end

  describe '#delivery_time' do
    it 'retorna prazo de entrega' do
      transport_model = TransportModel.create!(
        name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
        maximum_weight: 10_000, fixed_rate: 10, status: 'active'
      )
      delivery_time_index_first = DeliveryTimeTable.create!(
        start_range: 50, end_range: 60,
        delivery_time: 5, transport_model:
      )
      delivery_time_index_second = DeliveryTimeTable.create!(
        start_range: 60, end_range: 70,
        delivery_time: 5, transport_model:
      )
      distance = 65

      expect(transport_model.delivery_time(distance)).to eq delivery_time_index_second.delivery_time
    end

    it 'retorna zero quando distância não está contida em nenhum intervalo' do
      transport_model = TransportModel.create!(
        name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
        maximum_weight: 10_000, fixed_rate: 10, status: 'active'
      )
      delivery_time_index_first = DeliveryTimeTable.create!(
        start_range: 50, end_range: 60,
        delivery_time: 5, transport_model:
      )
      delivery_time_index_second = DeliveryTimeTable.create!(
        start_range: 60, end_range: 70,
        delivery_time: 5, transport_model:
      )
      distance = 80

      expect(transport_model.delivery_time(distance)).to eq 0
    end
  end

  describe '#shipping_price' do
    it 'retorna preço total de entrega' do
      transport_model = TransportModel.create!(
        name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
        maximum_weight: 10_000, fixed_rate: 10, status: 'active'
      )
      PriceByDistance.create(
        start_range: 50, end_range: 60,
        distance_tax: 5, transport_model:
      )
      PriceByWeight.create(
        start_range: 10, end_range: 200,
        price_for_kg: 0.2, transport_model:
      )

      distance = 55
      weight = 100

      expect(transport_model.shipping_price(weight, distance)).to eq 26
    end
  end
end
