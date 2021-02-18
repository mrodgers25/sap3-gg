class ChangeFKinImages < ActiveRecord::Migration[6.0]
  def change
    change_column :images, :url_id, 'integer USING CAST(url_id AS integer)'
  end
end
