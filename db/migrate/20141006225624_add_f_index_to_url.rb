class AddFIndexToUrl < ActiveRecord::Migration[6.0]
  def change
    add_index :urls, :story_id
  end
end
