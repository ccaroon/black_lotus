require 'spec_helper'

describe Card do
  
  context "validation" do
    it "should require a name" do
      c = FactoryGirl.build(:card, :name => nil)

      c.name.should be_nil
      c.should_not be_valid
      c.errors.messages.should have_key :name
    end

    it "should require at least one edition" do
      c = FactoryGirl.build(:card, :editions => [])

      c.editions.should_not be_present
      c.should_not be_valid
      c.errors.messages.should have_key :editions
    end

    it "should require a mana_cost if main_type is not land" do
      c = FactoryGirl.build(
        :card, 
        :mana_cost => nil, 
        :main_type => Card::CARD_TYPES[:creature]
      )

      c.mana_cost.should be_nil
      c.should_not be_valid
      c.errors.messages.should have_key :mana_cost
    end

    it "should not require mana_cost if main_type is a land" do
      c = FactoryGirl.build(
        :card, 
        :mana_cost => nil, 
        :main_type => Card::CARD_TYPES[:land]
      )

      c.mana_cost.should be_nil
      c.should be_valid
      c.errors.messages.should_not have_key :mana_cost
    end

    it "should require count to be an integer greater than zero" do
      c = FactoryGirl.build(:card, :count => nil)

      c.count.should be_nil
      c.should_not be_valid
      c.errors.messages.should have_key :count

      c.count = 1.5
      c.should_not be_valid
      c.errors.messages.should have_key :count

      c.count = 0
      c.should_not be_valid
      c.errors.messages.should have_key :count
    end

    it "should require that mana_cost have the correct format" do
      c = FactoryGirl.build(
        :card, 
        :mana_cost => 'hello',
      )

      c.should_not be_valid
      c.errors.messages.should have_key :mana_cost      
    end

    it "should require a valid main_type" do
      c = FactoryGirl.build(:card, :main_type => 'fubar')

      c.should_not be_valid
      c.errors.messages.should have_key :main_type
    end

    it "should require a valid rarity" do
      c = FactoryGirl.build(:card, :rarity => 'Super Rare')

      c.should_not be_valid
      c.errors.messages.should have_key :rarity
    end
  end

  it "can generate it's own image name" do
    c = FactoryGirl.build(:card, :name => 'Card 1')

    c.gen_image_name
    c.image_name.should_not be_nil
    c.image_name.should == 'card_1.jpg'
  end

  it "should fix_up data before validation" do
    c = FactoryGirl.build(:card, 
      :name      => 'bob the fisherman', 
      :mana_cost => '2u',
      :sub_type  => 'human fisherman'
    )

    c.valid?.should be_true

    c.name.should == 'Bob the Fisherman'
    c.mana_cost.should == '2U'
    c.sub_type.should == 'Human Fisherman'
  end

  it "can determine available editions" do
    editions = FactoryGirl.create_list(:edition, 5,
      :release_date => '2013-01-01')
    c = FactoryGirl.build(:card, :editions => [editions[0], editions[4]])

    avail_eds = c.available_editions
    avail_eds.count.should == 3
    avail_eds[0].name.should == editions[1].name
    avail_eds[1].name.should == editions[2].name
    avail_eds[2].name.should == editions[3].name
  end

  it "can determine if it's legal in different deck formats" do
    e = FactoryGirl.build(:edition, :name => "Dragon's Maze")
    recent_card = FactoryGirl.build(:card, :editions => [e])
    old_card    = FactoryGirl.build(:card)

    recent_card.should  be_legal Deck::FORMAT_STANDARD
    old_card.should_not be_legal Deck::FORMAT_STANDARD

    recent_card.should be_legal Deck::FORMAT_VINTAGE
    old_card.should    be_legal Deck::FORMAT_VINTAGE

    recent_card.should be_legal Deck::FORMAT_LEGACY
    old_card.should    be_legal Deck::FORMAT_LEGACY

    recent_card.should be_legal Deck::FORMAT_COMMANDER
    old_card.should    be_legal Deck::FORMAT_COMMANDER
  end

  it "can generate a list of sub_type strings" do
    FactoryGirl.create_list(:card, 25)

    sub_types = Card.sub_types
    sub_types.count.should == 10 #Card Factory cycles thru 10 diff sub_types
    sub_types[0].should be_a String
  end

  it "can find the total number of cards" do
    cards = FactoryGirl.create_list(:card, 100)

    total = 0
    cards.each do |c|
      total += c.count
    end

    Card.total.should == total
  end

end
