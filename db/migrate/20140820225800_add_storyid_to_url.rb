class AddStoryidToUrl < ActiveRecord::Migration
  def change
    add_column :urls, :story_id, :string
  end
end
