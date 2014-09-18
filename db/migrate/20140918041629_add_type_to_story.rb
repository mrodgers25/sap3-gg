class AddTypeToStory < ActiveRecord::Migration
  def change
    add_column :stories, :scraped_type, :string
  end
end
