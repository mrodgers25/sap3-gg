json.array!(@place_categories) do |place_category|
  json.extract! place_category, :id
  json.url place_category_url(place_category, format: :json)
end
