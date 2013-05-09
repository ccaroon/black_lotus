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

  validates_presence_of :name, :mana_cost, :editions
  validates_numericality_of :count, :only_integer => true, :greater_than => 0
  validates_format_of :mana_cost, :with => /^(\d+)?[RGUBW]*$/
  validates_inclusion_of :main_type, :in => CARD_TYPES,
    :message => "'%{value}' is not a valid main type"
  validates_inclusion_of :rarity, :in => RARITIES,
    :message => "'%{value}' is not a valid rarity"

  before_validation :fixup_data
  
  attr_accessible :count, :foil, :image_name, :main_type, :mana_cost, :name,
                  :rarity, :sub_type, :text_box
                  
  has_and_belongs_to_many :editions, :order => 'release_date'
  
  has_many :card_in_deck
  has_many :decks, :through => :card_in_deck
  ##############################################################################
  def gen_image_name
      iname = self.name.downcase
      iname.gsub!(/\s/, '_')
      iname.gsub!(/[^A-Za-z0-9\-_]/, '')
  
      self.image_name = iname + ".jpg"
  end
  ##############################################################################
  def available_editions
    recent_editions = Edition.recent_editions
    card_editions = self.editions
    
    avail_editions = recent_editions.keep_if do |e|
      card_editions.find_index(e).nil?
    end
  end
  ##############################################################################
  def self.sub_types
    Card.select("distinct sub_type")
      .delete_if {|c| c.sub_type.blank? }
      .collect! {|c| c.sub_type }
  end
  ##############################################################################
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
  ##############################################################################
  private
  
  def fixup_data
    self.name = Card.title_case(self.name)
    self.mana_cost.upcase!
    self.sub_type = Card.title_case(self.sub_type)
    self.gen_image_name
  end
  
end
