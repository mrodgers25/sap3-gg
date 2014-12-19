class UsersavedstoriesController < ApplicationController

  def my_stories
    if user_signed_in?
      @my_stories = Story.select("stories.story_year, stories.story_month, stories.story_date, urls.*, \
          usersavedstories.created_at as uss_created_at").joins(:usersavedstories). \
          joins(:urls).where("usersavedstories.user_id = #{current_user.id.to_i}").order("uss_created_at DESC")
    end
  end

  def destroy
    if user_signed_in?
      user_saved_story = Usersavedstory.where(story_id: params[:id], user_id: current_user.id).first
      user_saved_story.destroy
      redirect_to '/my_stories'
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  # def user_saved_story_params
  #   params.require(:usersavedstory).permit(:id, :user_id, :story_id)
  # end

end