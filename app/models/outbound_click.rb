class OutboundClick < ActiveRecord::Base
  validates :user_id, :url, presence: true
end
