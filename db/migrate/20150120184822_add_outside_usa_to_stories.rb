class AddOutsideUsaToStories < ActiveRecord::Migration
  def change
    add_column :stories, :outside_usa, :boolean
  end
end
