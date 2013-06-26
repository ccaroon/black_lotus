BlackLotus::Application.routes.draw do

  resources :cards
  match 'cards/:id/fetch_info' => 'cards#fetch_info', :as => :card_fetch_info

  resources :decks
  match 'decks/:id/build'      => 'decks#build',      :as => :build_deck
  match 'decks/:id/build_save' => 'decks#build_save', :as => :save_build_deck

  resources :editions

  # Utility routes
  match 'utilities/(index)' => 'utilities#index', 
    :via => :get, :as => :utilities
  match 'utilities/export_cards' => 'utilities#export_cards', 
    :as => :utils_export_cards
  match 'utilities/sync_db' => 'utilities#sync_db', 
    :as => :utils_sync_db

  root :to => 'home#index'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
