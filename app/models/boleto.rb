# frozen_string_literal: true

class Boleto < ApplicationRecord
  validates :amount, :expire_at, :customer_person_name, :customer_cnpj_cpf, :customer_state, :customer_city_name,
            :customer_zipcode, :customer_address, :customer_neighborhood, presence: true
end
