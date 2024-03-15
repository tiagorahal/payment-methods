require 'uri'
require 'net/http'
require 'json'

class KobanaService
    BASE_URL = "https://api-sandbox.kobana.com.br/v1/bank_billets"

  def initialize
    @token = "yvjdS4XepSEM5Sen-I63oBAW6Dq75XIZR0Uv0A244cY"
  end

  def create_boleto(params)
    uri = URI(BASE_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{@token}"
    request["Content-Type"] = 'application/json'
    request["Accept"] = 'application/json'
    request.body = params.to_json

    response = http.request(request)
    JSON.parse(response.body)
  end

  def update_boleto(id, params)
    uri = URI("#{BASE_URL}/#{id}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Put.new(uri)
    request["Authorization"] = "Bearer #{@token}"
    request["Content-Type"] = 'application/json'
    request["Accept"] = 'application/json'
    request.body = params.to_json

    response = http.request(request)
    JSON.parse(response.body)
  end

  def cancel_boleto(id)
    uri = URI("#{BASE_URL}/#{id}/cancel")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Put.new(uri)
    request["Authorization"] = "Bearer #{@token}"
    request["Content-Type"] = 'application/json'
    request["Accept"] = 'application/json'

    response = http.request(request)
    JSON.parse(response.body)
  end

  def list_boletos
    uri = URI(BASE_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer #{@token}"
    request["Accept"] = 'application/json'

    response = http.request(request)
    JSON.parse(response.body)
  end

  def get_boleto(id)
    uri = URI("#{BASE_URL}/#{id}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
  
    request = Net::HTTP::Get.new(uri)
    request["Authorization"] = "Bearer #{@token}"
    request["Accept"] = 'application/json'
  
    response = http.request(request)
    JSON.parse(response.body)
  end
end
