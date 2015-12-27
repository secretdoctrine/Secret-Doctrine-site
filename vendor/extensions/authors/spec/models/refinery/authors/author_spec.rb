require 'spec_helper'

module Refinery
  module Authors
    describe Author do
      describe "validations", type: :model do
        subject do
          FactoryGirl.create(:author,
          :name => "Refinery CMS")
        end

        it { should be_valid }
        its(:errors) { should be_empty }
        its(:name) { should == "Refinery CMS" }
      end
    end
  end
end
