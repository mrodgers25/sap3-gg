class NewsfeedActivity < ApplicationRecord
  belongs_to :trackable, polymorphic: true

  def self.activity_types
    %w[unpin post clear]
  end

  def time_to_hours(timestamp)
    return '-' unless timestamp

    "#{(timestamp / 3600).round(2)} hrs"
  end
end
