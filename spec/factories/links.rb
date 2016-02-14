FactoryGirl.define do
  factory :link do
    url Faker::Internet.url
    title Faker::Name.name
    description Faker::Lorem.sentence
  end
end
