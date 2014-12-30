class AddStorycompleteToStory < ActiveRecord::Migration
  def change
    add_column :stories, :story_complete, :boolean
  end
end
