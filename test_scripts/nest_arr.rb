ENV['RAILS_ENV'] ||= 'development'
require File.expand_path('../config/environment', __dir__)

location_hover_arr = Code.where("code_type = 'LOCATION_CODE' and code_key != ''").pluck('code_key', 'code_value')

location_hover_list = ''

location_hover_arr.each do |outer|
  outer.each_with_index do |inner, ndx|
    # location_hover_list << "#{ndx}"
    location_hover_list << '(' unless ndx == 1
    location_hover_list << inner.to_s
    location_hover_list << ') ' unless ndx == 1
  end
  location_hover_list << "\n"
end

# a = location_hover.each { |outer| puts "#{outer.to_s}" }

puts "location hover is #{location_hover_arr}"

puts "location_hover_list is #{location_hover_list}"
