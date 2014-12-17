class RemoveStoryidFromMediaowners < ActiveRecord::Migration
  def change
    remove_column :mediaowners, :story_id, :integer
  end
end
