require 'spec_helper'
require 'magic_cards_info'

describe "MagicCardsInfo" do

  it "can fetch a card's info" do
    edition = FactoryGirl.build(:edition, :online_code => 'm14')
    card = FactoryGirl.build(
      :card, 
      :name     => "Archangel of Thune",
      :editions => [edition]
    )

    info = MagicCardsInfo.fetch_info(card)
    info.should be_present

    info[:main_type].should == 'Creature'
    info[:sub_type].should  == 'Angel'
    info[:mana_cost].should == '3WW'
    info[:rarity].should    == 'Mythic Rare'
    info[:text_box].should  == "Flying\n\nLifelink (Damage dealt by this creature also causes you to gain that much life.)\n\nWhenever you gain life, put a +1/+1 counter on each creature you control."

  end

end
