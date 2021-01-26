class ChangeFKinUrls < ActiveRecord::Migration[6.0]
  def change
    change_column :urls, :story_id, 'integer USING CAST(story_id AS integer)'
  end
end
