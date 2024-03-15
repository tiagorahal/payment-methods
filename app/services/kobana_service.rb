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

  def update_boleto(id, boleto_params)
    Rails.logger.debug "KobanaService.update_boleto invoked with ID: #{id} and params: #{boleto_params}"

    url = "#{@base_url}/#{id}"
    headers = {
      'Authorization': "Bearer #{@token}",
      'Content-Type': 'application/json'
    }
    response = HTTParty.put(url, body: boleto_params.to_json, headers: headers)

    Rails.logger.debug "Sending HTTP PUT request to #{url} with body: #{boleto_params}"
    Rails.logger.debug "Received response: #{response.body}"

    response.parsed_response
  rescue StandardError => e
    Rails.logger.error "Error occurred in KobanaService.update_boleto: #{e.message}"
    { 'status' => 'error', 'message' => e.message }
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
  
    request = Net::HTTP::Get.new(uri) # Ensure it's a GET request
    request["Authorization"] = "Bearer #{@token}"
    request["Accept"] = 'application/json'
  
    response = http.request(request)
    JSON.parse(response.body)
  end
  
end
