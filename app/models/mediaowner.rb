class Mediaowner < ActiveRecord::Base
  validates :title, :presence => { :message => "TITLE is required" }
  validates :url_domain, :presence => { :message => "DOMAIN is required" }
  validates :url_domain, :uniqueness => { :message => "Duplicate domain" }

end
