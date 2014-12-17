json.array!(@mediaowners) do |mediaowner|
  json.extract! mediaowner, :id, :story_id, :title, :url, :url_domain, :owner_name, :media_type, :distribution_type, :publication_name, :paywall_yn, :content_frequency_time, :content_frequency_other, :content_frequency_guide, :nextissue_yn
  json.url mediaowner_url(mediaowner, format: :json)
end
