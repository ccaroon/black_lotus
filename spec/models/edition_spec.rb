require 'spec_helper'

describe Edition do

  context "recent editions" do

    before (:each) do
      FactoryGirl.create_list(:edition, 5, release_date: 7.months.ago )
      FactoryGirl.create_list(:edition, 5, release_date: 2.years.ago )
      FactoryGirl.create_list(:edition, 5, release_date: 3.months.ago )
    end

    it "should only show editions released in the last 2 years" do
      Edition.count.should == 15
      Edition.recent_editions.count.should == 10
    end
    
  end
end
