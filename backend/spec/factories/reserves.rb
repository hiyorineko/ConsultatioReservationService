FactoryBot.define do
  factory :reserve do
    association :user
    association :expert
    sequence(:start_at) { |n| "TEST_START_AT_#{n}"}
    sequence(:user_comment) { |n| "TEST_COMMENT_#{n}"}
  end
end
