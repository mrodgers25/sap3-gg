# url = Url.all

source_url_pre = 'http://austin.culturemap.com/news/restaurants-bars/01-16-15-new-restaurant-openings-ramen-tatsu-ya-juiceland-chilantro-luckys-fuzzys/'
full_url = Domainatrix.parse(source_url_pre).url
sub = Domainatrix.parse(source_url_pre).subdomain
domain = Domainatrix.parse(source_url_pre).domain
suffix = Domainatrix.parse(source_url_pre).public_suffix
prefix = (sub == 'www' || sub == '' ? '' : (sub + '.'))
@base_domain = prefix + domain + '.' + suffix


# url.each do |u|
#   sub = Domainatrix.parse(u.url_full).subdomain
#   domain = Domainatrix.parse(u.url_full).domain
#   suffix = Domainatrix.parse(u.url_full).public_suffix
#   prefix = (sub == 'www' || sub == '' ? '' : (sub + '.'))
#   d_url = prefix + domain + '.' + suffix
#   puts "parsed url is #{d_url}"
# end
#
#
# d_url = Domainatrix.parse(source_url_pre)
# @full_domain = d_url.host
# split_full_domain = @full_domain.split(".")
# if split_full_domain.length == 2
#   @base_domain = split_full_domain[0].to_s + "." + split_full_domain[1].to_s
# else
#   @base_domain = split_full_domain[1].to_s + "." + split_full_domain[2].to_s
# end