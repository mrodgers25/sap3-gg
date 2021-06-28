# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'fastimage'
doc = Nokogiri::HTML(open('http://www.huffingtonpost.com/2014/07/23/green-hotels-eco-friendly-travelers_n_5599709.html'))
# doc = Nokogiri::HTML(open("http://skift.com/2014/09/14/how-one-luxury-new-york-hotel-caters-to-independent-chinese-travelers"))

# get images
loop_counter = 0
found_counter = 0
page_imgs = {}

doc.css('img').each do |_i|
  src_url = doc.css('img')[loop_counter]['src'].to_s
  src_url_data_original = doc.css('img')[loop_counter]['data-original'].to_s
  src_url = src_url_data_original if src_url.empty?
  alt_text = doc.css('img')[loop_counter]['alt'].to_s

  if !src_url.empty? && (src_url.match(/(jpg|jpeg|gif|png)/i) && src_url.match(/(http)/i))
    begin
      image_size_array = FastImage.size(src_url, raise_on_failure: true)
      if image_size_array[0].to_i > 199
        puts "Found counter is: #{found_counter}"
        puts "src: #{src_url}"
        puts "img size: #{FastImage.size(src_url)}"
        puts "alt: #{alt_text}"
        page_imgs[found_counter] = { 'src_url' => src_url, 'alt_text' => alt_text }
        found_counter += 1
      end
    rescue StandardError
      puts 'FastImage error'
    end
  end
  puts "Loop counter is: #{loop_counter}"
  loop_counter += 1
  break if found_counter > 4
end

# puts "Image hash is: #{page_imgs}"
# puts "4th image is: #{page_imgs[3]}"
# puts "4th image src is: #{page_imgs[3]["src_url"]}"
# fourth_img = page_imgs[3]["src_url"]

puts "\nprinting out page_imgs array below vvvvv"
page_imgs.each do |key, array|
  concat_str = "key#{key}"
  puts "concat_str is #{concat_str}"
  puts array
  puts "src = #{page_imgs[key]['src_url']}"
  puts "alt = #{page_imgs[key]['alt_text']}"
end
