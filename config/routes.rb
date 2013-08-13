BlackLotus::Application.routes.draw do

  resources :cards
  get 'cards/:id/fetch_info' => 'cards#fetch_info', :as => :card_fetch_info

  resources :decks
  get 'decks/:id/build'      => 'decks#build',      :as => :build_deck
  get 'decks/:id/build_save' => 'decks#build_save', :as => :save_build_deck

  resources :editions

  # Utility routes
  get 'utilities/(index)' => 'utilities#index', 
    :as => :utilities
  get 'utilities/export_cards' => 'utilities#export_cards', 
    :as => :utils_export_cards
  get 'utilities/sync_db' => 'utilities#sync_db', 
    :as => :utils_sync_db

  root :to => 'home#index'

end
