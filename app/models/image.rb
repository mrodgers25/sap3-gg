class Image < ActiveRecord::Base
  belongs_to :url, inverse_of: :images
  # validates :src_url, presence: true
  attr_accessor :image_data
  # attr_accessor :page_imgs, :image_data

end
