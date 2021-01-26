class AddStoryCategoryToStory < ActiveRecord::Migration[6.0]
  def change
    add_column :stories, :story_category, :string
  end
end
