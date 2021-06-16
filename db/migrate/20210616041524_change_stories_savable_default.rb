class ChangeStoriesSavableDefault < ActiveRecord::Migration[6.1]
  def change
    change_column_default :stories, :savable, false
  end
end
