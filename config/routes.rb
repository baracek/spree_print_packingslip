Rails.application.routes.draw do
  namespace :admin do 
    resources :shipments do
      member do
        get :packingslip
      end
    end
  end
end
