class MediaInfo < ActiveRecord::Base
  belongs_to :story
  has_one :url
end
