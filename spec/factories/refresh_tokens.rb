FactoryBot.define do
  factory :refresh_token do
    user { nil }
    token { "MyString" }
    expires_at { "2024-07-26 12:29:27" }
  end
end
