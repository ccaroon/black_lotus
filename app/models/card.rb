require 'magic_cards_info'

class Card < ActiveRecord::Base
      
  CARD_TYPES = [
    'Basic Land',
    'Creature',
    'Instant',
    'Sorcery',
    'Land',
    'Artifact',
    'Artifact Creature',
    'Legendary Creature',
    'Enchantment',
    'Planeswalker'
  ]
  
  RARITIES = [
    'Common',
    'Uncommon',
    'Rare',
    'Mythic Rare'
  ]

  attr_accessible :count, :foil, :image_name, :main_type, :mana_cost, :name,
                  :rarity, :sub_type, :text_box
                  
  has_and_belongs_to_many :editions
  
  has_many :card_in_deck
  has_many :decks, :through => :card_in_deck
  
  def self.sub_types
    Card.select("distinct sub_type")
      .delete_if {|c| c.sub_type.blank? }
      .collect! {|c| c.sub_type }
  end
  
  def verify
    
  end
  
end
