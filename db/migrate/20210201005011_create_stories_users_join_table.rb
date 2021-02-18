class CreateStoriesUsersJoinTable < ActiveRecord::Migration[6.1]
  def change
    create_table :stories_users, id: false do |t|
      t.belongs_to :story
      t.belongs_to :user
    end
  end
end
