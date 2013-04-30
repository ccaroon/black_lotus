class CreateCards < ActiveRecord::Migration
  def change
    create_table :cards do |t|
      t.string  :name,       :null => false
      t.string  :mana_cost,  :null => false
      t.string  :main_type,  :null => false
      t.string  :sub_type,   :null => true
      t.boolean :foil,       :null => false, :default => false
      t.string  :rarity,     :null => false
      t.integer :count,      :null => false
      t.string  :image_name, :null => false
      t.text    :text_box,   :null => true

      t.timestamps
    end
  end
end
