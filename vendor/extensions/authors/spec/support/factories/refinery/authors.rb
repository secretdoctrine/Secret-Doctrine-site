
FactoryGirl.define do
  factory :author, :class => Refinery::Authors::Author do
    sequence(:name) { |n| "refinery#{n}" }
  end
end

