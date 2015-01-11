json.array!(@story_categories) do |story_category|
  json.extract! story_category, :id
  json.url story_category_url(story_category, format: :json)
end
