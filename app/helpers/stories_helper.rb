module StoriesHelper
  def review_admin_story_path_helper(story)
    case story.type
    when 'MediaStory'
      review_admin_media_story_path(story)
    when 'VideoStory'
      review_admin_video_story_path(story)
    end
  end

  def edit_admin_story_path_helper(story)
    case story.type
    when 'MediaStory'
      edit_admin_media_story_path(story)
    when 'VideoStory'
      edit_admin_video_story_path(story)
    end
  end

  def admin_story_path(story)
    case story.type
    when 'MediaStory'
      admin_media_story_path(story)
    when 'VideoStory'
      admin_video_story_path(story)
    end
  end
end
