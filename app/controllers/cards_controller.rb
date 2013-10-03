require 'magic_cards_info'
require 'utility'

class CardsController < ApplicationController
  # GET /cards
  # GET /cards.json
  def index

    where = [];
    if (params[:card].present?)
      params[:card].each do |key,value|
        next unless value.present?

        case key
        when 'name'
          where << "name like \"%#{value}%\""
        when 'color'
          where << "mana_cost like \"%#{value}%\""
        when 'text_box'
          where << "text_box like \"%#{value}%\""
        when 'sub_type'
          where << "sub_type like \"%#{value}%\""
        else
          where << "#{key} = \"#{value}\""
        end
      end
    end

    where_str = where.join(' and ')
    @cards = Card.where(where_str)
                 .order(:name)
                 .page(params[:page])

    @card_count = Card.where(where_str).count
    @total_card_count = Card.count

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cards, methods: :available_count }
    end
  end

  # GET /cards/1
  # GET /cards/1.json
  def show
    @card = Card.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @card, methods: :available_count }
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

    if @card.nil?
      @card = Card.new
      @card.count = 1
    end

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
        add_to_deck()

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
        add_to_deck()

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
  
  def add_to_deck
    if (params[:deck][:deck_id].present?)
      deck = Deck.find(params[:deck][:deck_id])
      deck.add_card(@card, {:main_copies => params[:deck][:count]})
    end
  end

  def add_edition
    ed_id = params[:card].delete(:editions)
    if (ed_id.present?)
      new_ed = Edition.find(ed_id)
      @card.editions << new_ed
    end    
  end
end
