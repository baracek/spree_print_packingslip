Rails.application.routes.draw do
  map.namespace :admin do |admin|
    admin.resources :shipments, :member => { :packingslip => :get }
  end
end
