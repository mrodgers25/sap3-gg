class MediaInfo < ApplicationRecord
  belongs_to :story
  has_one :url
end
