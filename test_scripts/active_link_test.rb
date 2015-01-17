# require "net/http"
require "fastimage"

def valid_url?(img_url)
  sz = FastImage.size(img_url)
  # FastImage.size(img_url, :raise_on_failure=>true)
  if sz.nil?
    puts 'nil'
    return false
  else
    puts sz
    return true
  end
end

if valid_url?('http://fodors.com/ee/images/article/killington-downhill.jpg') == false
  puts 'bad return'
else
  puts 'good return'
end