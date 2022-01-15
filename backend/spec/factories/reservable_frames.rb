FactoryBot.define do
  factory :reservable_frame do
    association :expert
    sequence(:start_at) { |n| Date.today + n}
  end
end
