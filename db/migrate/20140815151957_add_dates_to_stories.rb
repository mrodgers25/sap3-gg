class AddDatesToStories < ActiveRecord::Migration[6.0]
  def change
    add_column :stories, :story_month, :integer
    add_column :stories, :story_date, :integer
    add_column :stories, :story_year, :integer
  end
end
