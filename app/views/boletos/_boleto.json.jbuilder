json.extract! boleto, :id, :codigo, :vencimento, :valor, :created_at, :updated_at
json.url boleto_url(boleto, format: :json)
