# frozen_string_literal: true

FactoryBot.define do
  factory :place do
    name { 'MyString' }
    address { nil }
    place_status_option { nil }
    imported_place_id { 1 }
  end
end
