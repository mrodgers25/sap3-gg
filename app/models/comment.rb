# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  validates :reference, :reference_id, :note, presence: true
end
