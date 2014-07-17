json.array!(@stories) do |story|
  json.extract! story, :id, :url_id, :media_id, :story_type, :author, :publication_date
  json.url story_url(story, format: :json)
end
