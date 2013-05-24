require 'spec_helper'

describe Edition do

  context "recent editions" do

    before (:each) do
      FactoryGirl.create_list(:edition, 5, release_date: 2.years.ago )
      FactoryGirl.create_list(:edition, 5, release_date: 3.months.ago )
    end

    it "should only show editions released in the last 1 year" do
      Edition.count.should == 10
      Edition.recent_editions.count.should == 5
    end
    
  end
end
