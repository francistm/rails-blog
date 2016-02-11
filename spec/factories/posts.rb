require 'faker'

FactoryGirl.define do
  factory :post do
    association :admin

    slug { Faker::Internet.slug }
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }

    published_at Time.now
  end
end
