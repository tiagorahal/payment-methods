# frozen_string_literal: true

require 'test_helper'

class BoletosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @boleto = boletos(:one)
  end

  test 'should get index' do
    get boletos_url
    assert_response :success
  end

  test 'should get new' do
    get new_boleto_url
    assert_response :success
  end

  test 'should create boleto' do
    assert_difference('Boleto.count') do
      post boletos_url,
           params: { boleto: { codigo: @boleto.codigo, valor: @boleto.valor, vencimento: @boleto.vencimento } }
    end

    assert_redirected_to boleto_url(Boleto.last)
  end

  test 'should show boleto' do
    get boleto_url(@boleto)
    assert_response :success
  end

  test 'should get edit' do
    get edit_boleto_url(@boleto)
    assert_response :success
  end

  test 'should update boleto' do
    patch boleto_url(@boleto),
          params: { boleto: { codigo: @boleto.codigo, valor: @boleto.valor, vencimento: @boleto.vencimento } }
    assert_redirected_to boleto_url(@boleto)
  end

  test 'should destroy boleto' do
    assert_difference('Boleto.count', -1) do
      delete boleto_url(@boleto)
    end

    assert_redirected_to boletos_url
  end
end
