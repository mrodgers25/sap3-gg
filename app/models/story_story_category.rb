class StoryStoryCategory < ActiveRecord::Base
  validates :story_id, :story_category_id, presence: true
  validates :story_id, uniqueness: {scope: :story_category_id}

  belongs_to :story
  belongs_to :story_category
end
