json.array!(@media_infos) do |media_info|
  json.extract! media_info, :id, :media_type, :url_id, :media_desc
  json.url media_info_url(media_info, format: :json)
end
