class CreateCardInDecks < ActiveRecord::Migration
  def change
    create_table :card_in_decks, :id => false do |t|
      t.integer :card_id,     :null => false
      t.integer :deck_id,     :null => false
      t.integer :main_copies, :null => false
      t.integer :side_copies, :null => true
    end
  end
end
