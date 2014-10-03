class AddStoryCategoryToStory < ActiveRecord::Migration
  def change
    add_column :stories, :story_category, :string
  end
end
