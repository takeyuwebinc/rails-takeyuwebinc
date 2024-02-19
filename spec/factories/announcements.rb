FactoryBot.define do
  factory :announcement do
    sequence(:slug) { |i| "announcement-#{i}" }
    title { "MyText" }
    content { "<b>Content</b>" }

    trait :with_image do
      image { Rack::Test::UploadedFile.new(Rails.root.join("spec/fixtures/files/test.jpg"), "image/jpeg") }
    end
  end
end
