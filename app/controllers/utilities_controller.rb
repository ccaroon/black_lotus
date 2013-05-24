class UtilitiesController < ApplicationController
  #############################################################################
  def index
    render
  end
  #############################################################################
  def export_cards
    Utilities.export_cards
    render :json => {:message => "Success"}, :status => 200
  end
  #############################################################################
  def export_cards_progress
  end

end
