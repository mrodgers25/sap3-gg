class ChangeDefaultStoryState < ActiveRecord::Migration[6.1]
  def change
    change_column_default :stories, :state, 'no_status'
  end
end
