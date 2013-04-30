class CreateEditions < ActiveRecord::Migration
  def change
    create_table :editions do |t|
      t.string  :name,         :null => false
      t.string  :code_name,    :null => false
      t.string  :online_code,  :null => true
      t.date    :release_date, :null => false
      t.integer :card_count,   :null => false
    end
  end
end
