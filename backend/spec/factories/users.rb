FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "TEST_NAME#{n}"}
    sequence(:email) { |n| "TEST#{n}@example.com"}
    sequence(:password) { |n| "TEST_PASS_#{n}"}
    sequence(:password_confirmation) { |n| "TEST_PASS_#{n}"}
  end
end
