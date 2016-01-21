
FactoryGirl.define do
  factory :multimedia_group, :class => Refinery::MultimediaGroups::MultimediaGroup do
    sequence(:title) { |n| "refinery#{n}" }
  end
end

