# frozen_string_literal: true

class Usersavedstory < ApplicationRecord
  belongs_to :story
  belongs_to :user
  validates :user_id, uniqueness: { scope: :story_id }

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.find_each do |result|
        csv << result.attributes.values_at(*column_names)
      end
    end
  end
end
