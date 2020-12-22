class AddManualflgToImage < ActiveRecord::Migration[6.0]
  def change
    add_column :images, :manual_enter, :boolean
  end
end
