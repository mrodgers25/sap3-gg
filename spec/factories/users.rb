
# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { Faker::String.random(length: 8..12) }
    password_confirmation { password }
    role { 0 }
    city_preference { 'San Diego, Chicago, Los Angeles' }

    factory :admin_user do
      after(:create) do |user|
        user.role = 2
      end
    end
  end
end
