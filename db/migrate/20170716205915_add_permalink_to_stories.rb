class AddPermalinkToStories < ActiveRecord::Migration[6.0]
  def change
    add_column :stories, :permalink, :string
  end
end
