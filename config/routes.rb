Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'impressum' => 'site#imprint', as: :imprint

  get ':department/:paper' => 'paper#show', as: :paper
  get ':department' => 'department#show', as: :department #, department: /[a-z]+[\d]+/, format: false

  root 'site#root'
end
