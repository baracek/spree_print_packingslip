Rails.application.routes.draw do
  namespace :admin do 
    resources :shipments, :member => { :packingslip => :get }
  end
end
