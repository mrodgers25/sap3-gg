class Url < ActiveRecord::Base
  has_one :story
  validates :url_type, presence: true
  validates :url_title, presence: true
  validates :url_desc, presence: true
  validates :url_keywords, presence: true
end
