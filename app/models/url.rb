class Url < ActiveRecord::Base
  has_one :story
  has_one :media_info
end
