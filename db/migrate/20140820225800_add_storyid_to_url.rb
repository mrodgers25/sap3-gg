class AddStoryidToUrl < ActiveRecord::Migration[6.0]
  def change
    add_column :urls, :story_id, :string
  end
end
