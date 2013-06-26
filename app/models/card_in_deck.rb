class CardInDeck < ActiveRecord::Base
  attr_accessible :card, :deck, :main_copies, :side_copies
  
  belongs_to :card
  belongs_to :deck
end
