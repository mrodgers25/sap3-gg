module StoriesHelper
  def edit_admin_story_path_helper(story)
    case story.type
    when 'MediaStory'
      edit_admin_media_story_path(story)
    when 'VideoStory'
      edit_admin_video_story_path(story)
    end
  end

  def show_play_button(story)
    if story.video_story?
      image_pack_tag("youtube_social_icon_red.png", class: "video-play-icon")
    end
  end
end
