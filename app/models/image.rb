class Image < ApplicationRecord
  belongs_to :url, inverse_of: :images
  has_one_attached :figure
  validates :src_url, :presence => { :message => "IMAGE is required" }
  attr_accessor :image_data, :manual_url
  # attr_accessor :page_imgs, :image_data

  before_validation :check_manual_url, on: :create

  def check_manual_url
    self.src_url ||= self.manual_url
    self.manual_enter = (self.manual_url.present? ? true : false)
  end

  def attach_figure_with_src_url
    type = FastImage.type(self.src_url)
    if self.src_url.present? && type.present? && ['jpg', 'jpeg', 'gif', 'png'].include?(type.to_s)
      self.figure.attach(io: RemoteImageUploader.download_remote_file(self.src_url), filename: "image#{self.id}.#{type.to_s}", content_type: "image/#{type.to_s}")
    end
  end

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |result|
        csv << result.attributes.values_at(*column_names)
      end
    end
  end

end
