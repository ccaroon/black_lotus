class CardInDeck < ActiveRecord::Base
  attr_accessible :main_copies, :side_copies
  
  belongs_to :card
  belongs_to :deck
end
