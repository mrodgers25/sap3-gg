class AddReleaseSeqToStory < ActiveRecord::Migration
  def change
    add_column :stories, :release_seq, :integer
  end
end
