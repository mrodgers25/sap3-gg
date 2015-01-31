class CreateOutboundClicks < ActiveRecord::Migration
  def change
    create_table :outbound_clicks do |t|
      t.integer :user_id, null: false
      t.string :url, null: false
      t.timestamps
    end
  end
end
