FactoryBot.define do
  factory :comment do
    body { "This is a sample comment." }
    association :post
    association :user
  end
end