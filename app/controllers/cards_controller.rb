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
    @card = Card.new(params[:card])

    @card.mana_cost.upcase!
    @card.sub_type = Card.title_case(@card.sub_type)
    @card.gen_image_name

    respond_to do |format|
      if @card.save
        format.html { redirect_to @card, notice: 'Card was successfully created.' }
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

    @card.attributes = params[:card]
    
    @card.mana_cost.upcase!
    @card.sub_type = Card.title_case(@card.sub_type)
    @card.gen_image_name
        
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
end
