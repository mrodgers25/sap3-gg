# frozen_string_literal: true

FactoryBot.define do
  factory :place do
    name { 'MyString' }
    address { FactoryBot.create(:address) }
    place_status_option_id { FactoryBot.create(:place_status_option) }
    imported_place_id { 1 }
  end
end
