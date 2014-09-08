class Story < ActiveRecord::Base
  has_many :urls, inverse_of: :story
  accepts_nested_attributes_for :urls

  validates :story_type, presence: true
  validates :author, presence: true

  attr_accessor :source_url_pre

end
