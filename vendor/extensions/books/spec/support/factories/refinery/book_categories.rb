
FactoryGirl.define do
  factory :book_category, :class => Refinery::Books::BookCategory do
    sequence(:name) { |n| "refinery#{n}" }
  end
end

