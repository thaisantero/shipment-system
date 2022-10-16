# frozen_string_literal: true

module ApplicationHelper
  def formatted_cpf(cpf_number)
    CPF.new(cpf_number).formatted
  end

  def cep_formatted(cep)
    cep.gsub(/(\d{5})(\d{3})/, '\1-\2')
  end
end
