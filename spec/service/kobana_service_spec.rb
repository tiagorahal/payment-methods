require 'rails_helper'
require 'webmock/rspec'

RSpec.describe KobanaService do
  describe '#list_boletos' do
    let(:base_url) { "https://api-sandbox.kobana.com.br/v1/bank_billets" }
    let(:token) { "yvjdS4XepSEM5Sen-I63oBAW6Dq75XIZR0Uv0A244cY" }
    let(:stubbed_response) { [{ 'id' => 1, 'status' => 'active' }] }

    before do
      stub_request(:get, base_url)
        .with(headers: { 'Authorization' => "Bearer #{token}" })
        .to_return(body: stubbed_response.to_json, status: 200)
    end

    it 'requests the list of boletos from the API' do
      service = KobanaService.new
      expect(service.list_boletos).to eq(stubbed_response)
    end

    it 'handles the HTTP response correctly' do
      service = KobanaService.new
      response = service.list_boletos

      expect(response).to be_an_instance_of(Array)
      expect(response.first).to have_key('id')
      expect(response.first).to have_key('status')
    end

    describe '#get_boleto' do
      let(:base_url) { "https://api-sandbox.kobana.com.br/v1/bank_billets" }
      let(:boleto_id) { 635399 }
      let(:token) { "yvjdS4XepSEM5Sen-I63oBAW6Dq75XIZR0Uv0A244cY" }
      let(:stubbed_response) { { 'id' => boleto_id, 'amount' => 500.00, 'status' => 'active' } }

      before do
          stub_request(:get, "#{base_url}/#{boleto_id}")
          .with(headers: { 'Authorization' => "Bearer #{token}" })
          .to_return(body: stubbed_response.to_json, status: 200)
      end

      it 'requests the specific boleto from the API using the provided ID' do
          service = KobanaService.new
          boleto = service.get_boleto(boleto_id)

          expect(boleto).to be_a(Hash)
          expect(boleto['id']).to eq(boleto_id)
      end

      it 'handles the HTTP response correctly' do
          service = KobanaService.new
          boleto = service.get_boleto(boleto_id)

          expect(boleto['id']).to eq(boleto_id)
          expect(boleto['amount']).to eq(500.00)
          expect(boleto['status']).to eq('active')
      end             
    end
  end
end
