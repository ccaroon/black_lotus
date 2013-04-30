class Card < ActiveRecord::Base
  attr_accessible :count, :foil, :image_name, :main_type, :mana_cost, :name,
                  :rarity, :sub_type, :text_box
  has_and_belongs_to_many :editions
end
