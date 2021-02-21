class AddDescLengthToStories < ActiveRecord::Migration[6.1]
  def change
    add_column :stories, :desc_length, :integer, default: 200
  end
end
