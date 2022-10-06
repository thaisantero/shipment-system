require 'rails_helper'

describe 'Usuário vê modelos de transporte cadastrados' do
  it 'a partir do menu' do
    # Arrange
    # cadastrar dois galpoes: Rio e MAceio
    TransportModel.create(name: 'Express', minimum_distance: 50, maximum_distance: 200, minimum_weight: 10,
                          maximum_weight: 10_000, fixed_rate: 10)
    TransportModel.create(name: 'Bike', minimum_distance: 1, maximum_distance: 10, minimum_weight: 1,
                          maximum_weight: 10, fixed_rate: 5)

    # Act
    visit root_path
    click_on 'Modelos de Transporte'

    # Assert
    expect(page).not_to have_content('Nao existem modelos de transporte cadastrados')

    expect(page).to have_content('Intervalo de Distância aceitável')
    expect(page).to have_content('Intervalo de Peso suportável')
    expect(page).to have_content('Taxa Fixa')
    expect(page).to have_content('Express')
    expect(page).to have_content('50 - 200km')
    expect(page).to have_content('10 - 10000kg')
    expect(page).to have_content('R$10,00')
    expect(page).to have_content('Bike')
    expect(page).to have_content('1 - 10km')
    expect(page).to have_content('1 - 10kg')
    expect(page).to have_content('R$5,00')
  end
end
