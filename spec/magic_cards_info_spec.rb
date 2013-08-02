require 'spec_helper'

describe "MagicCardsInfo" do
  it "can parse HTML" do
    html = File.open("#{Rails.root}/spec/fixtures/card.html") do |file|
      file.read
    end

    html.should_not be_nil
    html.should_not be_empty

    info = MagicCardsInfo.parse_html(html)
    info.should be_present

    info[:main_type].should == 'Creature'
    info[:sub_type].should  == 'Human Soldier'
    info[:mana_cost].should == '2W'
    info[:text_box].should  == "Whenever Haazda Snare Squad attacks, you may pay {W}. If you do, tap target creature an opponent controls.\n\nHello World!"
  end
end
