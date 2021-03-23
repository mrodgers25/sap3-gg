class CreateAdminSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :admin_settings do |t|
      t.integer :newsfeed_size, default: 75
      t.integer :newsfeed_daily_post_count, default: 10

      t.timestamps
    end

    AdminSetting.create
  end
end
