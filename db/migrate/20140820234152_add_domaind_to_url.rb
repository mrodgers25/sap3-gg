class AddDomaindToUrl < ActiveRecord::Migration
  def change
    add_column :urls, :url_domain, :string
  end
end
