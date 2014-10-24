class AddManualflgToImage < ActiveRecord::Migration
  def change
    add_column :images, :manual_enter, :boolean
  end
end
