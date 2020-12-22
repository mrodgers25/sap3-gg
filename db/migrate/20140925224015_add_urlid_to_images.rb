class AddUrlidToImages < ActiveRecord::Migration[6.0]
  def change
    add_column :images, :url_id, :integer
  end
end
