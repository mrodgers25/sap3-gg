class UpdateStoryType < ActiveRecord::Migration[6.1]
  def change
    Story.where(type: nil).update_all(type: 'MediaStory')
  end
end
