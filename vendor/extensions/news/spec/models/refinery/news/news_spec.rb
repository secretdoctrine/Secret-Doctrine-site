require 'spec_helper'

module Refinery
  module News
    describe News do
      describe "validations", type: :model do
        subject do
          FactoryGirl.create(:news)
        end

        it { should be_valid }
        its(:errors) { should be_empty }
      end
    end
  end
end
