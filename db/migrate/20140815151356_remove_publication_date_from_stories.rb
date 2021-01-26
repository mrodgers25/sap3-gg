class RemovePublicationDateFromStories < ActiveRecord::Migration[6.0]
  def change
    remove_column :stories, :publication_date, :string
  end
end
