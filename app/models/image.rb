class Image < ActiveRecord::Base
  belongs_to :url, inverse_of: :images
  validates :src_url, presence: true
end
