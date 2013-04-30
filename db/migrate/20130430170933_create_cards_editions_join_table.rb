class CreateCardsEditionsJoinTable < ActiveRecord::Migration
  def change
    create_table :cards_editions, :id => false do |t|
      t.integer :card_id,    :null => false
      t.integer :edition_id, :null => false
    end
  end
end
