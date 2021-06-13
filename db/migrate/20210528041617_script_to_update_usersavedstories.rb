class ScriptToUpdateUsersavedstories < ActiveRecord::Migration[6.1]
  def change
    Usersavedstory.all.each do |association|
      user  = association.user
      story = association.story

      if user and story
        user.stories << story
        user.save
      end
    end
  end
end
