class BoletosController < ApplicationController
  def index
    kobana_service = KobanaService.new
    @boletos = kobana_service.list_boletos
  end

  def create
    kobana_service = KobanaService.new
    response = kobana_service.create_boleto(boleto_params)
  
    @boleto = response # Assuming response contains boleto data
  
    respond_to do |format|
      if response['status'] == 'success'
        format.html { redirect_to boletos_url, notice: 'Boleto was successfully created.' } # Redirect to root path
        format.json { render :show, status: :created, location: @boleto }
      else
        format.html { redirect_to boletos_url, alert: response['message'] || 'An error occurred while creating the boleto.' }
        format.json { render json: response, status: :unprocessable_entity }
      end
    end
  end

  def update
    kobana_service = KobanaService.new
    user_agent = "your_email@example.com"  # Replace with a valid email address
    idempotency_key = SecureRandom.uuid  # Generate a unique key for idempotency
    params[:boleto][:tags] = params[:boleto][:tags].split(',').map(&:strip) if params[:boleto][:tags].is_a?(String)

    params[:boleto][:days_for_sue] = params[:boleto][:days_for_sue].to_i if params[:boleto][:days_for_sue].is_a?(String)
  
    response = kobana_service.update_boleto(params[:id], boleto_params.to_h, user_agent, idempotency_key)

    respond_to do |format|
      if response['status'] == 'success'
        format.html { redirect_to boletos_url, notice: 'Boleto was successfully updated.' }
        format.json { render :show, status: :ok, location: @boleto }
      else
        format.html { redirect_to boletos_url, alert: response['message'] || 'An error occurred while updating the boleto.' }
        format.json { render json: response, status: :unprocessable_entity }
      end
    end
  rescue JSON::ParserError => e
    Rails.logger.error "JSON::ParserError: #{e.message}"
    redirect_to boletos_url, alert: 'An error occurred while processing the response.'
  rescue StandardError => e
    Rails.logger.error "Error: #{e.message}"
    redirect_to boletos_url, alert: 'An unexpected error occurred.'
  end

  # def destroy
  #   kobana_service = KobanaService.new
  #   cancellation_reason = params[:cancellation_reason]
  #   response = kobana_service.cancel_boleto(params[:id], cancellation_reason)
  
  #   respond_to do |format|
  #     if response['status'] == 'success'
  #       format.html { redirect_to boletos_url, notice: 'Boleto was successfully cancelled.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { redirect_to boletos_url, alert: 'Failed to cancel boleto.' }
  #       format.json { render json: response, status: :unprocessable_entity }
  #     end
  #   end
  # end  

  def cancel
    kobana_service = KobanaService.new
    cancellation_reason = params[:cancellation_reason]
    boleto_id = params[:id]

    response = kobana_service.cancel_boleto(boleto_id, cancellation_reason)

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

  def edit
    kobana_service = KobanaService.new
    @boleto = kobana_service.get_boleto(params[:id])
  
    if @boleto.blank?
      flash[:alert] = "Boleto not found"
      redirect_to boletos_url
    end
  end

  private

  def boleto_params
    params.require(:boleto).permit(
      :amount, :expire_at, :customer_person_name, :customer_cnpj_cpf,
      :customer_state, :customer_city_name, :customer_neighborhood,
      :customer_address, :notes, :days_for_sue, :sue_code, :instructions,
      :description, :reduction_amount, tags: []
    ).tap do |sanitized_params|
      sanitized_params[:customer_zipcode] = sanitized_params[:customer_zipcode].gsub(/[^0-9]/, '') if sanitized_params[:customer_zipcode]
    end
  end
   
end
