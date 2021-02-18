class AddKeywordsToUrl < ActiveRecord::Migration[6.0]
  def change
    add_column :urls, :url_keywords, :string
  end
end
