FactoryBot.define do
  factory :contact do
    name { "MyString" }
    company { "MyString" }
    email { "email@test.host" }
    phone { "00000000000" }
    message { "MyText " * 10 }
  end
end
