class Story < ActiveRecord::Base
  has_many :media_infos
  has_one :url
end
