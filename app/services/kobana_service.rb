require 'uri'
require 'net/http'
require 'json'

class KobanaService
  BASE_URL = 'https://api-sandbox.kobana.com.br/v1/bank_billets'.freeze

  def initialize
    @token = 'yvjdS4XepSEM5Sen-I63oBAW6Dq75XIZR0Uv0A244cY'
  end

  def create_boleto(params)
    uri = URI(BASE_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri)
    request['Authorization'] = "Bearer #{@token}"
    request['Content-Type'] = 'application/json'
    request['Accept'] = 'application/json'
    request.body = params.to_json

    response = http.request(request)
    Rails.logger.info("Boleto creation response: #{response.body}")
    JSON.parse(response.body)
  end

  def update_boleto(id, params, user_agent, idempotency_key)
    uri = URI("#{BASE_URL}/#{id}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Put.new(uri)
    request['Authorization'] = "Bearer #{@token}"
    request['Content-Type'] = 'application/json'
    request['Accept'] = 'application/json'
    request['User-Agent'] = user_agent
    request['X-Idempotency-Key'] = idempotency_key
    request.body = params.to_json

    Rails.logger.info("Request URI: #{uri}")
    Rails.logger.info("Request Body: #{request.body}")

    response = http.request(request)

    Rails.logger.info("Response Body: #{response.body}")

    JSON.parse(response.body)
  rescue JSON::ParserError => e
    Rails.logger.error("Failed to parse JSON: #{e.message}")
  end

  def cancel_boleto(id, cancellation_reason)
    uri = URI("#{BASE_URL}/#{id}/cancel")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Put.new(uri)
    request['Authorization'] = "Bearer #{@token}"
    request['Content-Type'] = 'application/json'
    request['Accept'] = 'application/json'
    request.body = { cancellation_reason: }.to_json

    response = http.request(request)
    JSON.parse(response.body)
  rescue JSON::ParserError, TypeError => e
    Rails.logger.error "Error processing the request: #{e.message}"
    { 'status' => 'error', 'message' => e.message }
  end

  def list_boletos
    uri = URI(BASE_URL)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{@token}"
    request['Accept'] = 'application/json'

    response = http.request(request)
    JSON.parse(response.body)
  end

  def get_boleto(id)
    uri = URI("#{BASE_URL}/#{id}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri)
    request['Authorization'] = "Bearer #{@token}"
    request['Accept'] = 'application/json'

    response = http.request(request)
    JSON.parse(response.body)
  end
end
