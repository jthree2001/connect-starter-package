Rails.application.routes.draw do
  root :to => "products#index"
  resources :products
  app_admin = lambda { |request| request.session["#{request.session['appInstance']}::admin"]}
  constraints app_admin do
    namespace :admin do
      get :delayedjob, to: 'application#delayedjob'
      match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]
      resources :app_instances, :only => [:index]
    end
  end
end
