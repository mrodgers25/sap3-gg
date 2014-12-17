class CreateMediaowners < ActiveRecord::Migration
  def change
    create_table :mediaowners do |t|
      t.integer :story_id
      t.string :title
      t.string :url
      t.string :url_domain
      t.string :owner_name
      t.string :media_type
      t.string :distribution_type
      t.string :publication_name
      t.boolean :paywall_yn
      t.string :content_frequency_time
      t.string :content_frequency_other
      t.string :content_frequency_guide
      t.boolean :nextissue_yn

      t.timestamps
    end
  end
end
