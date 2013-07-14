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

  it "can count the number of cards in the main deck"

  it "can count the number of card in the sideboard"

end
