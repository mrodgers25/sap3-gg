class PublishedItem < ApplicationRecord
  belongs_to :publishable, polymorphic: true

  validates_uniqueness_of :publishable_id, scope: :publishable_type
end
