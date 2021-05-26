class CustomStory < Story
  has_one_attached :internal_image
  has_rich_text :custom_body
end
