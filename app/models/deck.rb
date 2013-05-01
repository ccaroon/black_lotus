class Deck < ActiveRecord::Base
  attr_accessible :format, :name
  
  has_many :card_in_deck
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
