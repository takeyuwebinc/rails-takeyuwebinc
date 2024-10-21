FactoryBot.define do
  factory :client do
    slug { SecureRandom.uuid }
    name { "MyString" }
    kana { "MyString" }
    website { "MyString" }
  end
end
