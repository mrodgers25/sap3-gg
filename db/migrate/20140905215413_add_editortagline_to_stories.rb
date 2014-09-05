class AddEditortaglineToStories < ActiveRecord::Migration
  def change
    add_column :stories, :editor_tagline, :text
  end
end
