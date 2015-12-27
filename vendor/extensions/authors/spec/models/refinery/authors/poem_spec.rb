require 'spec_helper'

module Refinery
  module Authors
    describe Poem do
      describe "validations", type: :model do
        subject do
          FactoryGirl.create(:poem)
        end

        it { should be_valid }
        its(:errors) { should be_empty }
      end
    end
  end
end
