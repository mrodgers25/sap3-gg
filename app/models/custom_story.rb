class CustomStory < Story
  has_one_attached :internal_image
  has_rich_text :custom_body

  def display_title
    "#{type.titleize} #{id}"
  end

  def display_url
    '-'
  end

  def sorted_list_items
    list_items.includes(:story).order(:position, :created_at)
  end
end
