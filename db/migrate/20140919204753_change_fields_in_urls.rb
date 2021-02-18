class ChangeFieldsInUrls < ActiveRecord::Migration[6.0]
  def change
    change_column :urls, :url_desc, :text
    change_column :urls, :url_keywords, :text
  end
end
