class ChangeFieldsInUrls < ActiveRecord::Migration
  def change
    change_column :urls, :url_desc, :text
    change_column :urls, :url_keywords, :text
  end
end
