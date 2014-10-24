class Image < ActiveRecord::Base
  belongs_to :url, inverse_of: :images
  validates :src_url, :presence => { :message => "IMAGE is required" }
  attr_accessor :image_data, :manual_url
  # attr_accessor :page_imgs, :image_data

  before_validation :check_manual_url, on: :create

  def check_manual_url
    self.src_url ||= self.manual_url
    self.manual_enter = (self.manual_url.present? ? true : false)
  end

end
