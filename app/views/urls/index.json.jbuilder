json.array!(@urls) do |url|
  json.extract! url, :id, :url, :url_entered, :url_type, :url_title, :url_desc
  json.url url_url(url, format: :json)
end
