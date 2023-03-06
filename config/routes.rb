Rails.application.routes.draw do
  scope :v1 do
    namespace :users do
      get ':user_id/clock_ins', to: 'clock_ins#index', as: :clock_ins
      post ':user_id/clock_ins', to: 'clock_ins#create'
      get ':user_id/clock_outs', to: 'clock_outs#index', as: :clock_outs
      patch ':user_id/clock_outs', to: 'clock_outs#update'
      post ':user_id/friendships/follow', to: 'friendships#follow'
      delete ':user_id/friendships/unfollow', to: 'friendships#unfollow'
      get ':user_id/sleep_records', to: 'sleep_records#index', as: :sleep_records
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
