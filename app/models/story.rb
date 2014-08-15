class Story < ActiveRecord::Base
  belongs_to :url
  validates :story_type, presence: true
  validates :author, presence: true
end
