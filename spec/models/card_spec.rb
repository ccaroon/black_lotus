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
    c = FactoryGirl.build(:card)

    c.gen_image_name
    c.image_name.should_not be_nil
    c.image_name.should == 'card_1.jpg'
  end

  it "should fix_up data before validation"

  it "can determine available editions"

  it "can determine if it's legal in different deck formats"

  it "can generate a list of sub_type strings"

  it "can find the total number of cards"

end
