class MediaOwner < ApplicationRecord
  validates :title, presence: { message: 'TITLE is required' }
  validates :url_domain, presence: { message: 'DOMAIN is required' }
  validates :url_domain, uniqueness: { message: 'Duplicate domain' }

  belongs_to :url, foreign_key: 'url_domain', primary_key: 'url_domain', optional: true

  def self.to_csv
    CSV.generate do |csv|
      csv << column_names
      all.find_each do |result|
        csv << result.attributes.values_at(*column_names)
      end
    end
  end
end
