
FactoryGirl.define do
  factory :multimedia_item, :class => Refinery::MultimediaGroups::MultimediaItem do
    sequence(:title) { |n| "refinery#{n}" }
  end
end

