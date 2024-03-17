# frozen_string_literal: true

# spec/models/boleto_spec.rb

require 'rails_helper'

RSpec.describe Boleto, type: :model do
  it 'is valid with valid attributes' do
    boleto = Boleto.new(codigo: '123', vencimento: Date.today, valor: 100.00)
    expect(boleto).to be_valid
  end

  it 'is not valid without a codigo' do
    boleto = Boleto.new(vencimento: Date.today, valor: 100.00)
    expect(boleto).to_not be_valid
  end

  it 'is not valid without a vencimento' do
    boleto = Boleto.new(codigo: '123', valor: 100.00)
    expect(boleto).to_not be_valid
  end

  it 'is not valid without a valor' do
    boleto = Boleto.new(codigo: '123', vencimento: Date.today)
    expect(boleto).to_not be_valid
  end
end
