class Mediaowner < ActiveRecord::Base
  validates :url_domaim, :uniqueness => { :message => "Duplicate domain" }

end
