class AddStateToStories < ActiveRecord::Migration[6.1]
  def change
    add_column :stories, :state, :string
    add_index :stories, :state
  end
end
