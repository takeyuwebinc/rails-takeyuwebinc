FactoryBot.define do
  factory :page do
    title { Faker::Lorem.sentence }
    markdown { Faker::Lorem.paragraphs.join("\n\n") }
    path { "/#{Faker::Internet.slug}" }
  end
end
