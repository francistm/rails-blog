FactoryBot.define do
  factory :link, class: Link do
    url { Faker::Internet.url }
    title { Faker::Name.name }
    description { Faker::Lorem.sentence }
  end
end
