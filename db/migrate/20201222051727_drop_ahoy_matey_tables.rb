class DropAhoyMateyTables < ActiveRecord::Migration[6.1]
  def change
    drop_table :ahoy_events
  end
end
