class BoletosController < ApplicationController
  before_action :set_kobana_service

  def index
    @boletos = @kobana_service.list_boletos
  end

  def create
    response = @kobana_service.create_boleto(boleto_params)
    @boleto = response
    handle_create_response(response)
  end

  def update
    prepare_update_params
    response = @kobana_service.update_boleto(params[:id], boleto_params.to_h, @user_agent, @idempotency_key)
    handle_update_response(response)
  rescue JSON::ParserError => e
    log_error(e.message)
    redirect_to boletos_url, alert: 'An error occurred while processing the response.'
  rescue StandardError => e
    log_error(e.message)
    redirect_to boletos_url, alert: 'An unexpected error occurred.'
  end

  def cancel
    response = @kobana_service.cancel_boleto(params[:id], params[:cancellation_reason])
    handle_cancel_response(response)
  end

  def edit
    @boleto = @kobana_service.get_boleto(params[:id])
    redirect_to boletos_url, alert: 'Boleto not found' if @boleto.blank?
  end

  private

  def set_kobana_service
    @kobana_service = KobanaService.new
  end

  def prepare_update_params
    @user_agent = 'your_email@example.com'
    @idempotency_key = SecureRandom.uuid
    process_boleto_tags
    process_days_for_sue
  end

  def process_boleto_tags
    params[:boleto][:tags] = params[:boleto][:tags].split(',').map(&:strip) if params[:boleto][:tags].is_a?(String)
  end

  def process_days_for_sue
    params[:boleto][:days_for_sue] = params[:boleto][:days_for_sue].to_i if params[:boleto][:days_for_sue].is_a?(String)
  end

  def handle_create_response(response)
    respond_to do |format|
      if response['status'] == 'success'
        format.html { redirect_to boletos_url, notice: 'Boleto was successfully created.' }
        format.json { render :show, status: :created, location: @boleto }
      else
        format.html do
          redirect_to boletos_url, alert: response['message'] || 'An error occurred while creating the boleto.'
        end
        format.json { render json: response, status: :unprocessable_entity }
      end
    end
  end

  def handle_update_response(response)
    respond_to do |format|
      if response['status'] == 'success'
        format.html { redirect_to boletos_url, notice: 'Boleto was successfully updated.' }
        format.json { render :show, status: :ok, location: @boleto }
      else
        format.html do
          redirect_to boletos_url, alert: response['message'] || 'An error occurred while updating the boleto.'
        end
        format.json { render json: response, status: :unprocessable_entity }
      end
    end
  end

  def handle_cancel_response(response)
    respond_to do |format|
      if response['status'] == 'success'
        format.html { redirect_to boletos_url, notice: 'Boleto was successfully cancelled.' }
        format.json { head :no_content }
      else
        format.html { redirect_to boletos_url, alert: response['message'] || 'Failed to cancel boleto.' }
        format.json { render json: response, status: :unprocessable_entity }
      end
    end
  end

  def log_error(message)
    Rails.logger.error "Error: #{message}"
  end

  def boleto_params
    params.require(:boleto).permit(
      :amount, :expire_at, :customer_person_name, :customer_cnpj_cpf,
      :customer_state, :customer_city_name, :customer_neighborhood,
      :customer_address, :notes, :days_for_sue, :sue_code, :instructions,
      :description, :reduction_amount, tags: []
    ).tap do |sanitized_params|
      if sanitized_params[:customer_zipcode]
        sanitized_params[:customer_zipcode] =
          sanitized_params[:customer_zipcode].gsub(/[^0-9]/, '')
      end
    end
  end
end
