Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'search' => 'search#search', as: :search
  get 'search/autocomplete'
  get 'opensearch.xml' => 'search#opensearch', as: :opensearch, defaults: { format: 'xml' }

  get 'impressum' => 'site#imprint', as: :imprint

  get 'bt/:department/:paper' => 'paper#show', as: :paper
  get 'bt/:department' => 'department#show', as: :department #, department: /[a-z]+[\d]+/, format: false

  root 'site#root'
end
