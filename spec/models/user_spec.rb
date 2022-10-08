require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'válido?' do
    it 'nome é obrigatório' do
      user = User.create(name: '', email: 'user@sistemadefrete.com.br', password: 'password')

      result = user.valid?

      expect(result).to eq false
    end

    it 'e-mal tem que ter @ssitemadefrete.com.br' do
      user = User.create(name: 'User', email: 'user@email.com.br', password: 'password')

      result = user.valid?

      expect(result).to eq false
    end
  end
end
