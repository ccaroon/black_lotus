class AddIdToCardInDeck < ActiveRecord::Migration
  def change
    add_column :card_in_decks, :id, :primary_key, :null => false
  end
end
