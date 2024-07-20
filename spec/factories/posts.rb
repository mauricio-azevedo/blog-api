FactoryBot.define do
  factory :post do
    title { "Sample Post" }
    body { "This is a sample post" }
    association :user
  end
end