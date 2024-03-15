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
    kobana_service = KobanaService.new
    response = kobana_service.update_boleto(params[:id], boleto_params)
  
    respond_to do |format|
      if response['status'] == 'success'
        format.html { redirect_to boletos_url, notice: 'Boleto was successfully updated.' }
        format.json { render :show, status: :ok, location: @boleto }
      else
        format.html { render :edit }
        format.json { render json: response, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    kobana_service = KobanaService.new
    response = kobana_service.cancel_boleto(params[:id])

    respond_to do |format|
      if response['status'] == 'success'
        format.html { redirect_to boletos_url, notice: 'Boleto was successfully cancelled.' }
        format.json { head :no_content }
      else
        format.html { redirect_to boletos_url, alert: 'Failed to cancel boleto.' }
        format.json { render json: response, status: :unprocessable_entity }
      end
    end
  end

  def edit
    kobana_service = KobanaService.new
    @boleto = kobana_service.get_boleto(params[:id])
  
    if @boleto.blank?
      flash[:alert] = "Boleto not found"
      redirect_to boletos_path
    end
  end
  
  

  private

  def boleto_params
    params.require(:boleto).permit(:amount, :expire_at, :customer_person_name, :customer_cnpj_cpf, :customer_state, :customer_city_name, :customer_zipcode, :customer_address, :customer_neighborhood)
  end
end
