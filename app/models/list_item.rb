class ListItem < ApplicationRecord
  belongs_to :list
  belongs_to :story

  validates_presence_of :list, :story
  validates_uniqueness_of :story, scope: :list
end
