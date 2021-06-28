# frozen_string_literal: true

class Visit < ApplicationRecord
  belongs_to :user, polymorphic: true
end
