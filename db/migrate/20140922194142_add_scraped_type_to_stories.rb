class AddScrapedTypeToStories < ActiveRecord::Migration[6.0]
  def change
    add_column :stories, :scraped_type, :string
  end
end
