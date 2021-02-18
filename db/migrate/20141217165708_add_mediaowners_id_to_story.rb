class AddMediaownersIdToStory < ActiveRecord::Migration[6.0]
  def change
    add_column :stories, :mediaowner_id, :integer
    remove_column :stories, :media_id, :string
  end
end
