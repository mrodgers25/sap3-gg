# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    latitude { 1.5 }
    longitude { 1.5 }
    street_address { 'MyString' }
    post_office_box_number { 'MyString' }
    locality { 'MyString' }
    region { 'MyString' }
    postal_code { 'MyString' }
    country { 'MyString' }
    custom_1 { 'MyString' }
    custom_2 { 'MyString' }
  end
end
