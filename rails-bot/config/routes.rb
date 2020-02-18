Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root to: 'about#index'

  get '/about', to: 'about#index'


  scope :api do
    scope :v1 do
      post 'webhook', to: 'notifications#webhook'
    end
  end

end
