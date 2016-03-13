require 'sidekiq/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  sidekiq_web_constraint = ->(_, request) { ['::1', '127.0.0.1'].include?(request.remote_ip) || ENV['SIDEKIQ_WEB_OPEN'].present? }
  constraints sidekiq_web_constraint do
    mount Sidekiq::Web => '/sidekiq'
  end

  get 'search' => 'search#search', as: :search
  get 'search/autocomplete'
  get 'opensearch.xml' => 'search#opensearch', as: :opensearch, defaults: { format: 'xml' }

  get 'faq' => 'site#faq', as: :faq
  get 'impressum' => 'site#imprint', as: :imprint

  get 'static/sehrgutachten.svg', to: redirect { ActionController::Base.helpers.asset_path('sehrgutachten-logo.svg') }

  get 'status' => 'site#status'

  get 'recent' => 'site#recent', as: :recent, format: :atom

  put 'bt/:department/:paper' => 'paper#update', format: :txt
  get 'bt/:department/:paper' => 'paper#show', as: :paper
  get 'bt/:department' => 'department#show', as: :department #, department: /[a-z]+[\d]+/, format: false

  root 'site#root'
end
