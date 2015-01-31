class OutboundClick < ActiveRecord::Base
  validates :url, presence: true
end
