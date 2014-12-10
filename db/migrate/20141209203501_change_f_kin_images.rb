class ChangeFKinImages < ActiveRecord::Migration
  def change
    change_column :images, :url_id, 'integer USING CAST(url_id AS integer)'
  end
end
