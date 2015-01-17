u = Url.where("url_domain LIKE '%thrill%'")
u.each do |u|
  u.images.each do |i|
    puts "#{u.story_id}, #{i.src_url}"
  end
end
