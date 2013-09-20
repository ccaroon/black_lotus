require 'spec_helper'

describe Deck do

  context "validation" do
      it "requires a name" do
        d = FactoryGirl.build(:deck, :name => nil)

        d.name.should be_nil
        d.should_not be_valid
        d.errors.messages.should have_key :name
      end

      it "requires a format" do
        d = FactoryGirl.build(:deck, :format => nil)

        d.format.should be_nil
        d.should_not be_valid
        d.errors.messages.should have_key :format
      end
  end

  it "can count the number of cards in the main deck" do
    deck = FactoryGirl.build(:deck)
    cards = FactoryGirl.build_list(:card, 10)

    cards.each do |c|
      deck.add_card(c, {:main_copies => 3, :side_copies => 1})
    end

    deck.cards.count.should == 10
    deck.main_count.should == 30
  end

  it "can count the number of card in the sideboard" do
    deck = FactoryGirl.build(:deck)
    cards = FactoryGirl.build_list(:card, 15)

    cards.each do |c|
      deck.add_card(c, {:main_copies => 1, :side_copies => 3})
    end

    deck.cards.count.should == 15
    deck.side_count.should == 45
  end

end
