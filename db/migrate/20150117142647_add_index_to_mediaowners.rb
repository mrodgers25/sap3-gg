class AddIndexToMediaowners < ActiveRecord::Migration[6.0]
  def change
    add_index :mediaowners, :url_domain, unique: true
  end
end
