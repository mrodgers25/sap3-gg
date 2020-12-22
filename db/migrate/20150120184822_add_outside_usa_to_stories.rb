class AddOutsideUsaToStories < ActiveRecord::Migration[6.0]
  def change
    add_column :stories, :outside_usa, :boolean
  end
end
