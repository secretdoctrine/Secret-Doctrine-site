
FactoryGirl.define do
  factory :feedback_entry, :class => Refinery::FeedbackEntries::FeedbackEntry do
    sequence(:poster_name) { |n| "refinery#{n}" }
  end
end

