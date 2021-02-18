class AddDomaindToUrl < ActiveRecord::Migration[6.0]
  def change
    add_column :urls, :url_domain, :string
  end
end
