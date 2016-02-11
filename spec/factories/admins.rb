require 'faker'

FactoryGirl.define do
  factory :admin do
    nickname { Faker::Name.name }
    email { Faker::Internet.email }
    password '12345678'
    password_confirmation '12345678'
  end
end