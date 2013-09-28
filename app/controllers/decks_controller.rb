class DecksController < ApplicationController
  # GET /decks
  # GET /decks.json
  def index
    @decks = Deck.where("name like '%#{params[:search_string]}%'")
                  .order(:name)
                  .page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @decks }
    end
  end

  # GET /decks/1
  # GET /decks/1.json
  def show
    @deck = Deck.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @deck }
    end
  end

  # GET /decks/new
  # GET /decks/new.json
  def new
    @deck = Deck.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @deck }
    end
  end

  # GET /decks/1/edit
  def edit
    @deck = Deck.find(params[:id])
  end

  # POST /decks
  # POST /decks.json
  def create
    @deck = Deck.new(params[:deck])

    respond_to do |format|
      if @deck.save
        format.html { redirect_to @deck, notice: 'Deck was successfully created.' }
        format.json { render json: @deck, status: :created, location: @deck }
      else
        format.html { render action: "new" }
        format.json { render json: @deck.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /decks/1
  # PUT /decks/1.json
  def update
    @deck = Deck.find(params[:id])

    respond_to do |format|
      if @deck.update_attributes(params[:deck])
        format.html { redirect_to @deck, notice: 'Deck was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @deck.errors, status: :unprocessable_entity }
      end
    end
  end

  def build
    @deck = Deck.find(params[:id])
  end

  def build_save
    deck = Deck.find(params[:id])

    add_count = 0
    rm_count  = 0

    params.each do |key, card_data|
      case key
      when (/^add_card_/)
        parts = card_data.split('|')

        copy_opts = {
          :main_copies => 0,
          :side_copies => 0
        };

        case parts[1]
        when 'main' 
          copy_opts[:main_copies]  = parts[2]
        when 'side'
          copy_opts[:side_copies]  = parts[2]
        end

        card = Card.find(parts[0])
        deck.add_card(card, copy_opts)
        add_count+=1
      when (/^remove_card_/)
        card = Card.find(card_data)
        deck.remove_card(card)
        rm_count+=1
      end
    end

    redirect_to build_deck_path, 
      :notice => "Deck successfully updated. Added [#{add_count}] cards. Removed [#{rm_count}] cards."
  end

  # DELETE /decks/1
  # DELETE /decks/1.json
  def destroy
    @deck = Deck.find(params[:id])
    @deck.destroy

    respond_to do |format|
      format.html { redirect_to decks_url }
      format.json { head :no_content }
    end
  end
end
