require 'nokogiri'
require 'open-uri'
doc = Nokogiri::HTML(open("http://www.usatoday.com/experience/america/best-of-lists/10best-rock-and-roll-hotels-around-the-usa/15676735/"))

i = 0
while i < 10
  unless doc.css('img')[i]['src'].nil?
    img_src = doc.css('img')[i]['src']
    img_alt = doc.css('img')[i]['alt']
    puts "Image url is '#{img_src}'"
    puts "Image alt is #{img_alt}"
    puts " #{i}"
    i +=1
  end
end

# doc.css('img')[1].each do |i|
#   print i
# end
# puts "--------------------------\n"

# doc.css('img')[1].each do |k,v|
#   puts "#{k}: #{v}"
# end
# uts "--------------------------\n"
