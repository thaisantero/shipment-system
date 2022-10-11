require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  describe 'válido?' do
    context 'presença' do
      it 'falso quando placa de identificação está vazia' do
        transport_model = TransportModel.create!(
          name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
          maximum_weight: 10_000, fixed_rate: 10, status: 'active'
        )
        vehicle = Vehicle.create(
          identification_plate: '', vehicle_brand: 'Volkswagen',
          vehicle_type: 'Van 1.6 Mi', fabrication_year: 2016,
          max_load_capacity: 10_000, transport_model: transport_model
        )

        expect(vehicle).not_to be_valid
      end

      it 'falso quando marca está vazia' do
        transport_model = TransportModel.create!(
          name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
          maximum_weight: 10_000, fixed_rate: 10, status: 'active'
        )
        vehicle = Vehicle.create(
          identification_plate: 'PNG0000', vehicle_brand: '',
          vehicle_type: 'Van 1.6 Mi', fabrication_year: 2016,
          max_load_capacity: 10_000, transport_model: transport_model
        )

        expect(vehicle).not_to be_valid
      end

      it 'falso quando modelo está vazio' do
        transport_model = TransportModel.create!(
          name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
          maximum_weight: 10_000, fixed_rate: 10, status: 'active'
        )
        vehicle = Vehicle.create(
          identification_plate: 'PNG0000', vehicle_brand: 'Volkswagen',
          vehicle_type: '', fabrication_year: 2016,
          max_load_capacity: 10_000, transport_model: transport_model
        )

        expect(vehicle).not_to be_valid
      end

      it 'falso quando ano de fabricação está vazio' do
        transport_model = TransportModel.create!(
          name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
          maximum_weight: 10_000, fixed_rate: 10, status: 'active'
        )
        vehicle = Vehicle.create(
          identification_plate: 'PNG0000', vehicle_brand: 'Volkswagen',
          vehicle_type: 'Van 1.6 Mi', fabrication_year: '',
          max_load_capacity: 10_000, transport_model: transport_model
        )

        expect(vehicle).not_to be_valid
      end

      it 'falso quando capacidade máxima de carga está vazia' do
        transport_model = TransportModel.create!(
          name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
          maximum_weight: 10_000, fixed_rate: 10, status: 'active'
        )
        vehicle = Vehicle.create(
          identification_plate: 'PNG0000', vehicle_brand: 'Volkswagen',
          vehicle_type: 'Van 1.6 Mi', fabrication_year: 2016,
          max_load_capacity: '', transport_model: transport_model
        )

        expect(vehicle).not_to be_valid
      end
    end

    context 'valores únicos' do
      it 'falso quando placa de identificação já foi utilizada' do
        transport_model = TransportModel.create!(
          name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
          maximum_weight: 10_000, fixed_rate: 10, status: 'active'
        )
        Vehicle.create!(
          identification_plate: 'PNG0000', vehicle_brand: 'Volkswagen',
          vehicle_type: 'Van 1.6 Mi', fabrication_year: 2016,
          max_load_capacity: 10_000, transport_model: transport_model
        )
        vehicle = Vehicle.create(
          identification_plate: 'PNG0000', vehicle_brand: 'Fiat',
          vehicle_type: 'Fiat 1.8', fabrication_year: 2020,
          max_load_capacity: 1000, transport_model: transport_model
        )

        expect(vehicle).not_to be_valid
      end
    end

    context 'valores negativos' do
      it 'falso quando ano de fabricação for menor que zero' do
        transport_model = TransportModel.create!(
          name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
          maximum_weight: 10_000, fixed_rate: 10, status: 'active'
        )
        vehicle = Vehicle.create(
          identification_plate: 'PNG0000', vehicle_brand: 'Fiat',
          vehicle_type: 'Fiat 1.8', fabrication_year: -2020,
          max_load_capacity: 1000, transport_model: transport_model
        )

        expect(vehicle).not_to be_valid
      end

      it 'falso quando capacidade máxima de carga for menor que zero' do
        transport_model = TransportModel.create!(
          name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
          maximum_weight: 10_000, fixed_rate: 10, status: 'active'
        )
        vehicle = Vehicle.create(
          identification_plate: 'PNG0000', vehicle_brand: 'Fiat',
          vehicle_type: 'Fiat 1.8', fabrication_year: 2020,
          max_load_capacity: -1000, transport_model: transport_model
        )

        expect(vehicle).not_to be_valid
      end
    end

    context 'quantidade de caracteres' do
      it 'falso quando placa de identificação não tiver 7 caracteres' do
        transport_model = TransportModel.create!(
          name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
          maximum_weight: 10_000, fixed_rate: 10, status: 'active'
        )
        vehicle = Vehicle.create(
          identification_plate: 'PNGA0000', vehicle_brand: 'Fiat',
          vehicle_type: 'Fiat 1.8', fabrication_year: 2020,
          max_load_capacity: 1000, transport_model: transport_model
        )

        expect(vehicle).not_to be_valid
      end
    end
  end
end
