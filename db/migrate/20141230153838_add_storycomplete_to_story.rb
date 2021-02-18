class AddStorycompleteToStory < ActiveRecord::Migration[6.0]
  def change
    add_column :stories, :story_complete, :boolean
  end
end
