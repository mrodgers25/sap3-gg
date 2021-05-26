module StoriesHelper
  def edit_admin_story_path_helper(story)
    if story.media_story?
      edit_admin_media_story_path(story)
    elsif story.video_story?
      edit_admin_video_story_path(story)
    end
  end

  def show_play_button(story)
    if story.video_story?
      content_tag :i, '', class: "fas fa-play video_play_icon"
    end
  end
end
