require 'nokogiri'
require 'open-uri'
require 'fastimage'
doc = Nokogiri::HTML(open("http://www.latimes.com/food/la-fo-0927-virbila-sidebar-20140927-story.html"))

# get images
loop_counter = 0
found_counter = 0
page_imgs = Hash.new

doc.css('img').each do |i|
  src_url = doc.css('img')[loop_counter]['src'].to_s
  alt_text = doc.css('img')[loop_counter]['alt'].to_s
  unless src_url.empty?
    if src_url.match(/(jpg|jpeg|gif|png)/i) && src_url.match(/(http)/i)
      begin
        if FastImage.size(src_url, :raise_on_failure=>true)[0].to_i > 99
          puts "Found counter is: #{found_counter}"
          puts "src: #{src_url}"
          puts "img size: #{FastImage.size(src_url)}"
          puts "alt: #{alt_text}"
          page_imgs[found_counter] = { "src_url" => src_url, "alt_text" => alt_text }
          found_counter += 1
        end
      rescue
        puts "FastImage error"
      end
    end
  end
  puts "Loop counter is: #{loop_counter}"
  loop_counter += 1
  if found_counter > 9
    break
  end
end

# puts "Image hash is: #{page_imgs}"
# puts "4th image is: #{page_imgs[3]}"
# puts "4th image src is: #{page_imgs[3]["src_url"]}"
# fourth_img = page_imgs[3]["src_url"]

page_imgs.each do |key,array|
  concat_str = "key#{key}"
  puts "concat_str is #{concat_str}"
  puts array
  puts "src = #{page_imgs[key]["src_url"]}"
  puts "alt = #{page_imgs[key]["alt_text"]}"
end


