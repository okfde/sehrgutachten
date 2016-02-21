Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get 'impressum' => 'site#imprint', as: :imprint

  root 'site#root'
end
