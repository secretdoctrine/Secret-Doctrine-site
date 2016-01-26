require 'spec_helper'

module Refinery
  module Books
    describe BookCategory do
      describe "validations", type: :model do
        subject do
          FactoryGirl.create(:book_category,
          :name => "Refinery CMS")
        end

        it { should be_valid }
        its(:errors) { should be_empty }
        its(:name) { should == "Refinery CMS" }
      end
    end
  end
end
