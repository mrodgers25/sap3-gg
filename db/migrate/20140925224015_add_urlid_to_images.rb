class AddUrlidToImages < ActiveRecord::Migration
  def change
    add_column :images, :url_id, :integer
  end
end
