class CreateOutboundClicks < ActiveRecord::Migration[6.0]
  def change
    create_table :outbound_clicks do |t|
      t.integer :user_id
      t.string :url, null: false
      t.timestamps
    end
  end
end
