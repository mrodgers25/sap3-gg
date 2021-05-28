class Usersavedstory < ApplicationRecord
  belongs_to :story
  belongs_to :user
  validates_uniqueness_of :user_id, :scope => :story_id

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |result|
        csv << result.attributes.values_at(*column_names)
      end
    end
  end
end
