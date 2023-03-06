Rails.application.routes.draw do
  namespace :users do
    get ':user_id/clock_ins', to: 'clock_ins#index'
    post ':user_id/clock_ins', to: 'clock_ins#create'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
