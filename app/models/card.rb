require 'magic_cards_info'

class Card < ActiveRecord::Base
  
  LOWER_WORDS = {
    :the  => true,
    :in   => true,
    :of   => true,
    :a    => true,
    :to   => true,
    :by   => true,
    :from => true
  }
    
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

  def gen_image_name
      iname = self.name.downcase
      iname.gsub!(/\s/, '_')
      iname.gsub!(/[^A-Za-z0-9\-_]/, '')
  
      self.image_name = iname + ".jpg"
  end

  def self.title_case(str)
    new_str = ""

    str.split(/\s+/).each do |word|
      word.downcase!
      if (word.gsub!(/-/, ' '))
          word = title_case(word)
          word.gsub!(/ /, '-')
      else
          word.capitalize! unless LOWER_WORDS.has_key?(word.to_sym)
      end

      new_str += "#{word} "
    end
    new_str.chop!

    return new_str
  end
  
end
