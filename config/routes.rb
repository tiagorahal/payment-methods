# frozen_string_literal: true

Rails.application.routes.draw do
  resources :boletos do
    member do
      put :cancel
    end
  end

  root to: 'boletos#index'
end
