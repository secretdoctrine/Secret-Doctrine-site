require 'spec_helper'

module Refinery
  module NewsItems
    describe NewsItem do
      describe "validations", type: :model do
        subject do
          FactoryGirl.create(:news_item)
        end

        it { should be_valid }
        its(:errors) { should be_empty }
      end
    end
  end
end
