# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    user { 1 }
    reference { 'MyString' }
    reference_id { 1 }
    note { 'MyText' }
  end
end
