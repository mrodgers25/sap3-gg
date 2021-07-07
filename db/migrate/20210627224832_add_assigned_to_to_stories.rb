class AddAssignedToToStories < ActiveRecord::Migration[6.1]
  def change
    add_column :stories, :assigned_to, :integer
    add_index :stories, :assigned_to
  end
end
