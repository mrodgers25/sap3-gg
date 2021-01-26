class RemoveStoryidFromMediaowners < ActiveRecord::Migration[6.0]
  def change
    remove_column :mediaowners, :story_id, :integer
  end
end
