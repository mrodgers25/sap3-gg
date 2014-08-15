class RemovePublicationDateFromStories < ActiveRecord::Migration
  def change
    remove_column :stories, :publication_date, :string
  end
end
