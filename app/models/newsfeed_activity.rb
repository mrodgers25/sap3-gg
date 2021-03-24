class NewsfeedActivity < ApplicationRecord
  belongs_to :trackable, polymorphic: true
  validates_uniqueness_of :trackable_id, scope: :trackable_type
end
