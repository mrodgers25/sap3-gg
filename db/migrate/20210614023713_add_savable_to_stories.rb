class AddSavableToStories < ActiveRecord::Migration[6.1]
  def change
    add_column :stories, :savable, :boolean, default: true
  end
end
