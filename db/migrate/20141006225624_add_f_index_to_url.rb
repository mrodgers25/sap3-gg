class AddFIndexToUrl < ActiveRecord::Migration
  def change
    add_index :urls, :story_id
  end
end
