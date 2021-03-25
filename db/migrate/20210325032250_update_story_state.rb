class UpdateStoryState < ActiveRecord::Migration[6.1]
  def change
    Story.where(state: 'published').update_all(state: 'completed')
    Story.where(state: 'draft').update_all(state: 'no_status')
    Story.where(state: 'approved').update_all(state: 'needs_review')
    Story.where(state: 'archived').update_all(state: 'removed_from_public')
  end
end
