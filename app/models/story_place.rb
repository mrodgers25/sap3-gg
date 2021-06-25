class StoryPlace < ApplicationRecord
  belongs_to :story
  belongs_to :place
end
