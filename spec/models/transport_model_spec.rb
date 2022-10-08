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
end
