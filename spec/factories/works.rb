FactoryBot.define do
  factory :work do
    slug { SecureRandom.uuid }
    title { "MyString" }
    client
    points { "Line1\nLine2\nLine3" }
    position { 1 }
  end
end
