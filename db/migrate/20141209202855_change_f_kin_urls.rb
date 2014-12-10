class ChangeFKinUrls < ActiveRecord::Migration
  def change
    change_column :urls, :story_id, 'integer USING CAST(story_id AS integer)'
  end
end
