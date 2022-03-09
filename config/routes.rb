Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "default#index"
  get 'timeline', to: "default#timeline"
  get 'data', to: "default#data"
  get 'involved', to: "default#involved"
  get 'housing', to: "default#housing"
  get 'policing', to: "default#policing"
  get 'contact', to: "default#contact"
  get 'about', to: "default#about"
  get 'connections', to: "default#connections"
end
