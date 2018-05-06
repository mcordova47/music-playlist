FactoryBot.define do
  factory :song do
    video { Faker::Internet.slug }
    title { Faker::Lorem.word }
    artist { Faker::Lorem.word }
    year { Faker::Number.number(4) }
    album { Faker::Lorem.word }
    notes { Faker::Lorem.words }
  end
end
