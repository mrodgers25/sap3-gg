class AddEditortaglineToStories < ActiveRecord::Migration[6.0]
  def change
    add_column :stories, :editor_tagline, :text
  end
end
