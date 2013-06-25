require "handbase_sync"
require 'utility'

class UtilitiesController < ApplicationController
  #############################################################################
  def index
    render
  end
  ##############################################################################
  # New File Delivered is a CSV file
  # Importing CSV File
  # Magic Cards.PDB
  # Found existing database
  # Received CSV File OK
  ##############################################################################
  def sync_db
    host = params[:host]

    begin
      HanDBaseSync.sync_db(host)
      flash[:notice] = "Card Database successfully sync'd."
    rescue Exception => e
      flash[:alert] = "Unable to sync Card Database: #{e}"
    end

    redirect_to utilities_path
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
