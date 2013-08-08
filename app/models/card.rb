class Card < ActiveRecord::Base
  
  LOWER_WORDS = {
    the:  true,
    in:   true,
    of:   true,
    a:    true,
    to:   true,
    by:   true,
    from: true
  }
    
  CARD_TYPES = {
    basic_land:         'Basic Land',
    creature:           'Creature',
    instand:            'Instant',
    sorcery:            'Sorcery',
    land:               'Land',
    artifact:           'Artifact',
    artifact_creature:  'Artifact Creature',
    legendary_artifact: 'Legendary Artifact',
    legendary_creature: 'Legendary Creature',
    enchantment:        'Enchantment',
    planeswalker:       'Planeswalker',
    scheme:             'Scheme'
  }
  
  COLORS = {
    red:   { name: 'Red',   code: 'R' },
    green: { name: 'Green', code: 'G' },
    blue:  { name: 'Blue',  code: 'U' },
    black: { name: 'Black', code: 'B' },
    white: { name: 'White', code: 'W' }
  }

  RARITIES = [
    'Common',
    'Uncommon',
    'Rare',
    'Mythic Rare'
  ]

  validates_presence_of :name, :editions
  validates_presence_of :mana_cost,
    :unless => Proc.new {|card| card.main_type =~ /Land$/ }
  validates_numericality_of :count, :only_integer => true, :greater_than => 0
  validates_format_of :mana_cost, 
    :with => /^(X|\d+)?({[RGUBW]\/[RGUBW]}|[RGUBW])*$/
  validates_inclusion_of :main_type, :in => CARD_TYPES.values,
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
    all_editions = Edition.order('release_date').all
    card_editions = self.editions
    
    avail_editions = all_editions.keep_if do |e|
      card_editions.find_index(e).nil?
    end
  end
  ##############################################################################
  def latest_edition
    return (editions.last)
  end
  ##############################################################################
  def is_red?
    !(mana_cost =~ /#{COLORS[:red][:code]}/).nil?
  end
  ##############################################################################
  def is_green?
    !(mana_cost =~ /#{COLORS[:green][:code]}/).nil?
  end
  ##############################################################################
  def is_blue?
    !(mana_cost =~ /#{COLORS[:blue][:code]}/).nil?
  end
  ##############################################################################
  def is_black?
    !(mana_cost =~ /#{COLORS[:black][:code]}/).nil?
  end
  ##############################################################################
  def is_white?
    !(mana_cost =~ /#{COLORS[:white][:code]}/).nil?
  end
  ##############################################################################
  def is_colorless?
    !mana_cost.empty? and !is_red? and !is_green? and !is_blue? and !is_black? and !is_white?
  end
  ##############################################################################
  def converted_mana_cost
    cost = nil
    mc = self.mana_cost

    # Find instances of either/or colors and change to M for Multi b/c they will
    # only count as 1
    mc.gsub!(/{.\/.}/, 'M')

    if mc.sub!(/^(\d)/, '')
      cost = $1.to_i
      cost += mc.length
    elsif mc.sub!(/^X/, '')
      cost = mc.length + 1
    else
      cost = mc.length
    end

    return(cost)
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
  def self.total
    total = Card.connection.select_one("select sum(count) as count from cards")
    return(total['count'])
  end
  ##############################################################################
  private
  
  def fixup_data
    unless (self.name.nil?)
      self.name = Card.title_case(self.name)
      self.gen_image_name
    end

    self.mana_cost.upcase! unless self.mana_cost.nil?
    self.sub_type = Card.title_case(self.sub_type) unless self.sub_type.nil?
  end
  
end
