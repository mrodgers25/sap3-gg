class ExternalImage < ApplicationRecord
  belongs_to :story

  validates_presence_of :src_url
end
