Rails.application.routes.draw do
  resources :boletos
  root to: 'boletos#index'
end
