# frozen_string_literal: true

class OutboundClick < ApplicationRecord
  validates :url, presence: true
end
