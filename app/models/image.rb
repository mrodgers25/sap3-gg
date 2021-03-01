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

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.each do |result|
        csv << result.attributes.values_at(*column_names)
      end
    end
  end

end
