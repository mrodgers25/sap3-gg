class Usersavedstory < ActiveRecord::Base
  belongs_to :story
  validates_uniqueness_of :user_id, :scope => :story_id

end