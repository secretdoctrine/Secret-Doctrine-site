require 'spec_helper'

module Refinery
  module FeedbackEntries
    describe FeedbackEntry do
      describe "validations", type: :model do
        subject do
          FactoryGirl.create(:feedback_entry,
          :poster_name => "Refinery CMS")
        end

        it { should be_valid }
        its(:errors) { should be_empty }
        its(:poster_name) { should == "Refinery CMS" }
      end
    end
  end
end
