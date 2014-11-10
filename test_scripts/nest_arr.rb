ENV['RAILS_ENV'] ||= 'development'
require File.expand_path('../../config/environment', __FILE__)


location_hover = Code.where("code_type = 'LOCATION_CODE'").pluck("code_key","code_value")


# a = location_hover.each do |outer|
#   # outer.each do |inner|
#     puts "#{outer} "
#   # end
# end

a = location_hover.each { |outer| puts "#{outer.to_s}" }

