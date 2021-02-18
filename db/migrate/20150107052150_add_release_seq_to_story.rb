class AddReleaseSeqToStory < ActiveRecord::Migration[6.0]
  def change
    add_column :stories, :release_seq, :integer
  end
end
