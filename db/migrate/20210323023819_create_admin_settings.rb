class CreateAdminSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :admin_settings do |t|
      t.integer :newsfeed_display_limit, default: 75
      t.integer :filtered_display_limit, default: 36
      t.integer :newsfeed_daily_post_count, default: 10

      t.timestamps
    end

    AdminSetting.create
  end
end
