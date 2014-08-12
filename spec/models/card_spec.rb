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

    describe "mana_cost" do
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

      it "should be correctly formatted" do
        c = FactoryGirl.build(:card)

        c.mana_cost = 'XRGB'
        c.should be_valid

        c.mana_cost = '2RGB'
        c.should be_valid

        c.mana_cost = 'RGB'
        c.should be_valid

        c.mana_cost = 'X'
        c.should be_valid

        c.mana_cost = '7'
        c.should be_valid

        c.mana_cost = 'red'
        c.should_not be_valid

        # spaces not allowed
        c.mana_cost = 'r g b'
        c.should_not be_valid

        # Can contain X and a number i.e. Soul Burn
        c.mana_cost = 'X2'
        c.should be_valid

        c.mana_cost = 'X2B'
        c.should be_valid

        c.mana_cost = 'X12GW'
        c.should be_valid

        # Can contain multiple X's i.e. Meteor Shower
        c.mana_cost = 'XXR'
        c.should be_valid

        c.mana_cost = 'XX2g'
        c.should be_valid

        # If contain number and X, X must be first
        c.mana_cost = '7X'
        c.should_not be_valid
        c.errors.messages.should have_key :mana_cost

        # X must be a the beginning
        c.mana_cost = 'RGBX'
        c.should_not be_valid
        c.errors.messages.should have_key :mana_cost      

        # digits must be at the beginning
        c.mana_cost = 'RGB7'
        c.should_not be_valid
        c.errors.messages.should have_key :mana_cost      

      end

      it "supports either-or colors, i.e. {B/R}" do
        c = FactoryGirl.build(:card)

        c.mana_cost = '2{B/R}{B/R}'
        c.should be_valid

        c.mana_cost = '{G/W}'
        c.should be_valid

        c.mana_cost = 'X{U/R}'
        c.should be_valid

        c.mana_cost = 'X{U/R}G'
        c.should be_valid

        c.mana_cost = 'X{U/R}G{U/R}'
        c.should be_valid

        # Only one slash allowed
        c.mana_cost = '2{R/B/G}'
        c.should_not be_valid

        # Must include a slash
        c.mana_cost = '{RR}'
        c.should_not be_valid

        # missing second color
        c.mana_cost = '{R/}'
        c.should_not be_valid

        # missing first color
        c.mana_cost = '{/G}'
        c.should_not be_valid

        # too many first colors
        c.mana_cost = '{RR/B}'
        c.should_not be_valid

        # too many second colors
        c.mana_cost = '{R/BB}'
        c.should_not be_valid
      end

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

  it "should fix_up data before validation" do
    c = FactoryGirl.build(:card, 
      :name      => 'bob the fisherman', 
      :mana_cost => '2u',
      :sub_type  => 'human fisherman'
    )

    c.valid?.should be_truthy

    c.name.should == 'Bob the Fisherman'
    c.mana_cost.should == '2U'
    c.sub_type.should == 'Human Fisherman'
  end

  it "should be able to compute converted mana cost" do
    card = FactoryGirl.build(:card, :mana_cost => '2W')
    card.converted_mana_cost.should == 3

    card.mana_cost = 'X'
    card.converted_mana_cost.should == 1

    card.mana_cost = '7'
    card.converted_mana_cost.should == 7

    card.mana_cost = 'W'
    card.converted_mana_cost.should == 1

    card.mana_cost = '{G/W}'
    card.converted_mana_cost.should == 1

    card.mana_cost = 'X{U/R}G{U/R}'
    card.converted_mana_cost.should == 4

    card.mana_cost = '3{U/R}G{U/R}'
    card.converted_mana_cost.should == 6

    card.mana_cost= 'WG'
    card.converted_mana_cost.should == 2

    card.mana_cost= 'WGGG'
    card.converted_mana_cost.should == 4

    card.mana_cost = 'XW'
    card.converted_mana_cost.should == 2
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

  it "can determine used count" do
    deck = FactoryGirl.build(:deck)
    card = FactoryGirl.build(:card, :count => 10)

    deck.add_card(card, {:main_copies => 2, :side_copies => 2})
    deck.cards.count.should == 1

    card.count.should == 10
    card.used_count.should == 4
  end

  it "can determine available count" do
    deck = FactoryGirl.build(:deck)
    card = FactoryGirl.build(:card, :count => 7)

    deck.add_card(card, {:main_copies => 2, :side_copies => 1})
    deck.cards.count.should == 1

    card.count.should == 7
    card.used_count.should == 3
    card.available_count.should == 4
  end

  context "title case" do
    it "knows how to title case a string with hyphens" do
      name = Card.title_case('akki blizzard-herder')
      name.should == 'Akki Blizzard-Herder'
    end

    it "honors lower-case word list" do
      lower_words_str = Card::LOWER_WORDS.keys.join(' ').upcase
      name = Card.title_case(lower_words_str)

      name.should == lower_words_str.downcase
    end

  end

  context "image_name and image_path" do

    it "can generate it's own image name" do
      c = FactoryGirl.build(:card, :name => 'Card 1')

      c.gen_image_name
      c.image_name.should_not be_nil
      c.image_name.should == 'card_1.jpg'
    end

    it "should use the image of the latest edition by default" do
      card = FactoryGirl.build(:card)

      latest_ed    = card.latest_edition
      image_name   = card.image_name
      name_with_ed = image_name.sub(/\.jpg/, "-#{latest_ed.code_name.downcase}.jpg")

      image_path = card.image_path
      image_path.should == "/card_images/#{name_with_ed}"
    end

    it "can determine the image_path based on the card's edition" do
      card    = FactoryGirl.build(:card) 
      edition = FactoryGirl.build(:edition)

      image_name   = card.image_name
      name_with_ed = image_name.sub(/\.jpg/, "-#{edition.code_name.downcase}.jpg")

      image_path = card.image_path(edition)
      image_path.should == "/card_images/#{name_with_ed}"
    end  

  end

  context "introspection" do

    it "can determine if it's a land" do
      card1 = FactoryGirl.build(:card, :main_type => Card::CARD_TYPES[:land])
      card2 = FactoryGirl.build(:card, :main_type => Card::CARD_TYPES[:basic_land])
      card3 = FactoryGirl.build(:card, :main_type => Card::CARD_TYPES[:creature])

      card1.is_land?.should be_truthy
      card2.is_land?.should be_truthy
      card3.is_land?.should be_falsey
    end

    it "can determine if it's red" do
      card = FactoryGirl.build(:card, :mana_cost => 'R')
      card.is_red?.should be_truthy
    end

    it "can determine if it's green" do
      card = FactoryGirl.build(:card, :mana_cost => 'G')
      card.is_green?.should be_truthy
    end

    it "can determine if it's blue" do
      card = FactoryGirl.build(:card, :mana_cost => 'U')
      card.is_blue?.should be_truthy
    end

    it "can determine if it's black" do
      card = FactoryGirl.build(:card, :mana_cost => 'B')
      card.is_black?.should be_truthy
    end

    it "can determine if it's white" do
      card = FactoryGirl.build(:card, :mana_cost => 'W')
      card.is_white?.should be_truthy
    end

    it "can determine if it's colorless" do
      card = FactoryGirl.build(:card, :mana_cost => '15')
      card.is_colorless?.should be_truthy
    end

    it "can determine if it's multi-colored" do
      card1 = FactoryGirl.build(:card, :mana_cost => 'RG')
      card1.is_multicolored?.should be_truthy

      card2 = FactoryGirl.build(:card, :mana_cost => 'X{R/B}')
      card2.is_multicolored?.should be_truthy

      card3 = FactoryGirl.build(:card, :mana_cost => '2UW')
      card3.is_multicolored?.should be_truthy

      card4 = FactoryGirl.build(:card, :mana_cost => 'G')
      card4.is_multicolored?.should be_falsey

      card5 = FactoryGirl.build(:card, :mana_cost => 'GG')
      card5.is_multicolored?.should be_falsey

      card6 = FactoryGirl.build(:card, :mana_cost => '')
      card6.is_multicolored?.should be_falsey

      card7 = FactoryGirl.build(:card, :mana_cost => nil)
      card7.is_multicolored?.should be_falsey

      card8 = FactoryGirl.build(:card, :mana_cost => '7')
      card8.is_multicolored?.should be_falsey
    end

  end

end
