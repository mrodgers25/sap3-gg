module StoriesHelper
  def edit_admin_story_path_helper(story)
    case story.type
    when 'MediaStory'
      edit_admin_media_story_path(story)
    when 'VideoStory'
      edit_admin_video_story_path(story)
    end
  end

  def show_visual_media(story, id)
    case story.type
    when 'MediaStory'
      if story.latest_image
        link_to image_pack_tag('default-image.jpeg', onload: "const mainContentWidth = document.getElementById('main-content').offsetWidth; const divWidth = document.getElementById('grid-card-#{id}').offsetWidth; const ratio = (divWidth / #{story.image_width.to_f}); const newHeight = (ratio * #{story.image_height.to_f}); this.style.height=newHeight+'px';", class: "grid-image"), story_path(story.permalink), target: '_blank', id: "default-image-#{id}"
        link_to image_tag(story.latest_image.src_url, onload: "this.style.display='inline'; document.getElementById('default-image-#{id}').style.display='none';", class: "grid-image", style: 'display: none;'), story_path(story.permalink), target: '_blank'
      else
        link_to image_pack_tag('default-image.jpeg', class: "grid-image"), story_path(story.permalink), target: '_blank'
      end
    when 'VideoStory'
      content_tag :div, class: "p-3" do
        get_video_iframe(story.latest_url&.url_full, width = "100%", height = "100%")
      end
    end
  end
end