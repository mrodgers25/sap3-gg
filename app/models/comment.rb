class Comment < ApplicationRecord
  belongs_to :user
  validates :reference, :reference_id, :note, presence: true 
end
