class CustomStory < Story
  has_many_attached :internal_images
  has_rich_text :custom_body

  def display_title
    editor_tagline
  end

  def display_url
    '-'
  end

  def sorted_list_items
    list_items.includes(:story).order(:position, :created_at)
  end

  def show_carousel?
    (internal_images.size > 1) || (internal_images.size == 1 && external_image.present?)
  end

  def image_count
    internal_count = internal_images.size
    external_count = external_image.present? ? 1 : 0

    internal_count + external_count
  end
end
