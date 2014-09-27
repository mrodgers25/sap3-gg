class Image < ActiveRecord::Base
  belongs_to :url, inverse_of: :images
  # validates :src_url, presence: true
  attr_accessor :page_imgs

  before_save :set_image_fields, on: :create

  def set_image_fields
    # self.src_url = self.src_url["src_url"]
    # self.src_url = @image_url_text["src_url"]
    self.alt_text = @page_imgs[0]["alt_text"]
  end
end
