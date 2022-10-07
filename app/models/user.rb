class EmailValidator < ActiveModel::Validator
  def validate(record)
    unless record.email.include? '@sistemadefrete.com.br'
      record.errors.add :email, "inválido."
    end
  end
end


class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :email, email: true
  validates :name, presence: true
end
