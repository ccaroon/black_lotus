require 'magic_cards_info'
require 'utility'

class CardsController < ApplicationController
  # GET /cards
  # GET /cards.json
  def index

    where_str = "";
    if (params[:search_string].present?)
      where_str = "name like '%#{params[:search_string]}%'";
    elsif (params[:card].present? and params[:card][:main_type].present?)
      where_str = "main_type = '#{params[:card][:main_type]}'";
    end

    @cards = Card.where(where_str)
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

    redirect_action = :show

    add_edition()
    @card.attributes = params[:card]

    if (@card.valid?)
      begin
        @card_data_mismatches = Utility.fetch_card_info(@card)
        redirect_action = :edit unless @card_data_mismatches.empty?
      rescue Exception => e
        case e.message
        when /card .* not found/i
          flash[:alert] = e.message
          redirect_action = :edit
        else
          flash[:alert] = "Failed to fetch card info for verification: #{e}"
        end
      end
    end

    respond_to do |format|
      if @card.save
        format.html {
          if redirect_action == :edit
            render 'cards/edit'
          else
            redirect_to @card, notice: 'Card was successfully created.'
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
  def fetch_info
    @card = Card.find(params[:id])
    @card_data_mismatches = Utility.fetch_card_info(@card)

    if (@card_data_mismatches.empty?)
      @card.save
      redirect_to @card, notice: 'Success!'
    else
      render 'cards/edit'
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
