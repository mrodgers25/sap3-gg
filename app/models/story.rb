class Story < ActiveRecord::Base
  has_many :media_infos
  has_one :url
  attr_accessor :source_url
  if @source_url_changed
    flash[:error] = 'url has changed'
  end
end
