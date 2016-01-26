
FactoryGirl.define do
  factory :book, :class => Refinery::Books::Book do
    sequence(:name) { |n| "refinery#{n}" }
  end
end

