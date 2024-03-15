class BoletosController < ApplicationController
  def index
    kobana_service = KobanaService.new
    @boletos = kobana_service.list_boletos
  end

  def create
    kobana_service = KobanaService.new
    response = kobana_service.create_boleto(boleto_params)

    respond_to do |format|
      if response['status'] == 'success'
        format.html { redirect_to boletos_url, notice: 'Boleto was successfully created.' }
        format.json { render :show, status: :created, location: @boleto }
      else
        format.html { render :new }
        format.json { render json: response, status: :unprocessable_entity }
      end
    end
  end

  def update
    Rails.logger.debug "Started PUT \"/boletos/#{params[:id]}\" for ::1 at #{Time.now} -0300"
    Rails.logger.debug "Processing by BoletosController#update as TURBO_STREAM"
    Rails.logger.debug "Parameters: #{params.inspect}"

    Rails.logger.debug "Starting update in BoletosController with ID: #{params[:id]}"
    kobana_service = KobanaService.new
    Rails.logger.debug "Calling KobanaService.update_boleto with params: #{boleto_params}"
    
    response = kobana_service.update_boleto(params[:id], boleto_params)
    
    Rails.logger.debug "Response from KobanaService.update_boleto: #{response}"
    
    if response['status'] == 'success'
      redirect_to boletos_url, notice: 'Boleto was successfully updated.'
    else
      redirect_to boletos_url, alert: response['message'] || 'An error occurred while updating the boleto.'
    end
  end
  

  def destroy
    kobana_service = KobanaService.new
    response = kobana_service.cancel_boleto(params[:id])

    respond_to do |format|
      if response['status'] == 'success'
        format.html { redirect_to root_url, notice: 'Boleto was successfully cancelled.' }
        format.json { head :no_content }
      else
        format.html { redirect_to root_url, alert: 'Failed to cancel boleto.' }
        format.json { render json: response, status: :unprocessable_entity }
      end
    end
  end

  def edit
    kobana_service = KobanaService.new
    @boleto = kobana_service.get_boleto(params[:id])
  
    if @boleto.blank?
      flash[:alert] = "Boleto not found"
      redirect_to root_url
    end
  end

  private

  def boleto_params
    params.require(:boleto).permit(:amount, :expire_at, :tags, :notes, :days_for_sue, :sue_code, :instructions, :description, :reduction_amount)
  end
  
  
end
