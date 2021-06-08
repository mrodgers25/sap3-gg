class List < ApplicationRecord
  belongs_to :story
  has_many :list_items

  validates_presence_of :story
end
