FactoryBot.define do
  factory :reserve do
    association :user
    association :expert
    sequence(:start_at) { |n| (Date.today + n).to_time }
    sequence(:user_comment) { |n| "TEST_COMMENT_#{n}"}
  end
end
