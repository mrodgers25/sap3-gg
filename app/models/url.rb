class Url < ActiveRecord::Base
  belongs_to :story, inverse_of: :urls
  validates :url_type, presence: true
  validates :url_title, presence: true
  validates :url_desc, presence: true
  validates :url_keywords, presence: true
  validates :url_domain, presence: true
end
