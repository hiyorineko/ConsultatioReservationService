FactoryBot.define do
  factory :expert_type do
    sequence(:name) { |n| "TEST_TYPE_#{n}"}
  end
end
