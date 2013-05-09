require 'magic_cards_info'

class CardsController < ApplicationController
  # GET /cards
  # GET /cards.json
  def index
    @cards = Card.where("name like '%#{params[:search_string]}%'") 
                 .order(:name)
                 .page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cards }
    end
  end

  # GET /cards/1
  # GET /cards/1.json
  def show
    @card = Card.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @card }
    end
  end

  # GET /cards/new
  # GET /cards/new.json
  def new
    name = params[:name]
    if (name.present?)
      name = Card.title_case(name)
      @card = Card.where(:name => name).first
    end

    @card = Card.new if @card.nil?

    respond_to do |format|
      format.html {
        if (@card.id.present?)
          flash[:info] = "Found Card: '#{@card.name}'"
          redirect_to :action => 'edit', :id => @card.id
        else
          if (name.present?)
            @card.name = name
            render
          else
            render :file => '/cards/new_search'
          end
        end
      }
      format.json { render json: @card }
    end
  end

  # GET /cards/1/edit
  def edit
    @card = Card.find(params[:id])
  end

  # POST /cards
  # POST /cards.json
  def create
    @card = Card.new()

    add_edition()
    @card.attributes = params[:card]
    success = @card.save

    # fetch card info
    
    # if success, then compare values
    # if all match, redirect to show page
    # if not all match, redirect to edit page with array of mis-matches
    
    # if fetch fails, redirect to show with "failed to fetch" message

    notice = 'Card was successfully created.'
    redirect_action = :show
    @card_data_mismatches = []
    begin
      info = MagicCardsInfo.fetch_info(@card)
      MagicCardsInfo.fetch_image(@card, info[:image_url])
      
      info.delete(:image_url)
      info.each_pair do |attr, val|
        m = @card.method(attr)
        @card_data_mismatches << {:name => attr, :value => val} unless m.call == val
      end
      redirect_action = :edit unless @card_data_mismatches.empty?
    rescue Exception => e
      flash[:alert] = "Failed to fetch card info for verification: #{e}"
    end

    respond_to do |format|
      if success
        format.html {
          if redirect_action == :edit
            redirect_to :action => 'edit', :id => @card.id
          else
            redirect_to @card, notice: notice
          end
        }
        format.json { render json: @card, status: :created, location: @card }
      else
        format.html { render action: "new" }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /cards/1
  # PUT /cards/1.json
  def update
    @card = Card.find(params[:id])

    add_edition()
    @card.attributes = params[:card]

    respond_to do |format|
      if @card.save
        format.html { redirect_to @card, notice: 'Card was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cards/1
  # DELETE /cards/1.json
  def destroy
    @card = Card.find(params[:id])
    @card.destroy

    respond_to do |format|
      format.html { redirect_to cards_url }
      format.json { head :no_content }
    end
  end
  ##############################################################################
  private
  
  def add_edition
    ed_id = params[:card].delete(:editions)
    if (ed_id.present?)
      new_ed = Edition.find(ed_id)
      @card.editions << new_ed
    end    
  end
end
