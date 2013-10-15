class HomeController < ApplicationController

  def index
    @cards = Card.where('main_type = ? or main_type = ?', 
                        Card::CARD_TYPES[:legendary_creature],
                        Card::CARD_TYPES[:planeswalker])
                 .order("random()").limit(25)

    render
  end

end
