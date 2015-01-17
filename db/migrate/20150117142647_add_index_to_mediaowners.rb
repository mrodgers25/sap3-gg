class AddIndexToMediaowners < ActiveRecord::Migration
  def change
    add_index :mediaowners, :url_domain, unique: true
  end
end
