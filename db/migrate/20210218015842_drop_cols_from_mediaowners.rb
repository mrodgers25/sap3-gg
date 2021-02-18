class DropColsFromMediaowners < ActiveRecord::Migration[6.1]
  def change
    remove_column :mediaowners, :url_full
    remove_column :mediaowners, :owner_name
    remove_column :mediaowners, :media_type
    remove_column :mediaowners, :distribution_type
    remove_column :mediaowners, :publication_name
    remove_column :mediaowners, :paywall_yn
    remove_column :mediaowners, :content_frequency_time
    remove_column :mediaowners, :content_frequency_other
    remove_column :mediaowners, :content_frequency_guide
    remove_column :mediaowners, :nextissue_yn

    rename_table :mediaowners, :media_owners
  end
end
