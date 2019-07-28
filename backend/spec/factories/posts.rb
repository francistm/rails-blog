require 'faker'

FactoryBot.define do
  factory :post, class: Post do
    association :admin

    slug { Faker::Internet.slug }
    title { Faker::Lorem.sentence }
    content { Faker::Lorem.paragraph }

    published_at { Time.now }
  end
end
