Rails.application.routes.draw do
  resources :recognitions
  root 'recognitions#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
