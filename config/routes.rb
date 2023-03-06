Rails.application.routes.draw do
  namespace :users do
    get ':user_id/clock_ins', to: 'clock_ins#index'
    post ':user_id/clock_ins', to: 'clock_ins#create'
    get ':user_id/clock_outs', to: 'clock_outs#index'
    patch ':user_id/clock_outs', to: 'clock_outs#update'
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
