class HomeController < ApplicationController

  def index
    @cards = Card.order("random()").limit(25)
    render
  end

end
