module StoriesHelper
  def edit_admin_story_path_helper(story)
    if story.media_story?
      edit_admin_media_story_path(story)
    elsif story.video_story?
      edit_admin_video_story_path(story)
    else
      edit_admin_custom_story_path(story)
    end
  end

  def show_play_button(story)
    if story.video_story?
      image_pack_tag("youtube_social_icon_red.png", class: "video-play-icon")
    end
  end

  def story_icon(story)
    if story.media_story?
      'fas fa-book'
    elsif story.video_story?
      'fas fa-video'
    else
      'fas fa-asterisk'
    end
  end
end
