require "handbase_sync"
require 'utility'

class UtilitiesController < ApplicationController
  #############################################################################
  def index
    render
  end
  ##############################################################################
  def sync_db
    host = params[:host]
    HanDBaseSync.sync_db(host)

    redirect_to :index
  end
  #############################################################################
  def export_cards
    file_name = Utility.export_cards
    render :json => {:message => "Success"}, :status => 200
  end
  #############################################################################
  def export_cards_progress
  end

end
