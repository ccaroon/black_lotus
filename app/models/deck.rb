class Deck < ActiveRecord::Base
  
  #TODO: Factor these FORMATS out to their own class
  FORMAT_STANDARD = {
    :name           => 'Standard',
    :min_cards      => 60,
    :max_cards      => nil,
    :sideboard_size => 15,
    :max_copies     => 4,
    :legal_editions => [
      'Innistrad',
      'Dark Ascension',
      'Avacyn Restored',
      'Magic 2013',
      'Return to Ravnica',
      'Gatecrash',
      'Dragon\'s Maze'
    ],
    :has_banned_cards     => 0,
    :has_restricted_cards => 0
  }

  FORMAT_VINTAGE = {
    :name           => 'Vintage',
    :min_cards      => 60,
    :max_cards      => nil,
    :sideboard_size => 15,
    :max_copies     => 4,
    # All Edition are legal
    :legal_editions => nil,
    :has_banned_cards     => 1,
    :has_restricted_cards => 1
  }

  FORMAT_LEGACY = {
    :name           => 'Legacy',
    :min_cards      => 60,
    :max_cards      => nil,
    :sideboard_size => 15,
    :max_copies     => 4,
    # All Edition are legal
    :legal_editions => nil,
    :has_banned_cards     => 1,
    :has_restricted_cards => 0
  }

  FORMAT_COMMANDER = {
    :name           => 'Commander',
    :alt_name       => 'Elder Dragon Highlander',
    :min_cards      => 100,
    :max_cards      => 100,
    :sideboard_size => 15,
    :max_copies     => 1,
    # All Edition are legal
    :legal_editions => nil,
    :has_banned_cards     => 0,
    :has_restricted_cards => 0
  }

  FORMATS = {
    FORMAT_STANDARD[:name]  => FORMAT_STANDARD,
    FORMAT_LEGACY[:name]    => FORMAT_LEGACY,
    FORMAT_VINTAGE[:name]   => FORMAT_VINTAGE,
    FORMAT_COMMANDER[:name] => FORMAT_COMMANDER
  }
  ##############################################################################
  attr_accessible :name, :format

  validates_presence_of :name, :format

  has_many :card_in_deck, :order => 'main_copies asc'
  has_many :cards, :through => :card_in_deck
  ##############################################################################
  def main_count
    count = 0
    card_in_deck.each do |a|
      count += a.main_copies
    end
    
    return (count);
  end
  ##############################################################################
  def side_count
    count = 0
    card_in_deck.each do |a|
      count += a.side_copies
    end
    
    return (count);
  end
  
end
