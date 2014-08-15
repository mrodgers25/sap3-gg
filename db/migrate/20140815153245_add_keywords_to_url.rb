class AddKeywordsToUrl < ActiveRecord::Migration
  def change
    add_column :urls, :url_keywords, :string
  end
end
