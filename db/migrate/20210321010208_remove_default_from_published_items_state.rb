class RemoveDefaultFromPublishedItemsState < ActiveRecord::Migration[6.1]
  def change
    change_column_default :published_items, :state, nil
  end
end
