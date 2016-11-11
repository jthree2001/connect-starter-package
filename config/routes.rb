Rails.application.routes.draw do
  root :to => "products#index"
  resources :products
  app_admin = lambda { |request| request.session["#{request.session['appInstance']}::admin"]}
  constraints app_admin do
    namespace :admin do
      resources :app_instances, :only => [:index]
    end
  end
end
