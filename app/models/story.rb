class Story < ActiveRecord::Base
  has_many :urls, inverse_of: :story
  accepts_nested_attributes_for :urls

  validates :story_type, presence: true
  validates :author, presence: true

  attr_accessor :source_url_pre

  # before_create :set_track_flag
  #
  # def set_track_flag
  #   # Story.update_attribute(:url_title_track => true) # undefined method `update_attributes'
  #   # self.url_title_track = true # undefined method `url_title_track='
  #   # @story.url_title_track = true # undefined method `url' for nil:NilClass
  #   # @story.url.url_title_track = true # undefined method `url' for nil:NilClass
  #   # :url_title_track = true if @title_scrape == params[:story][:url_title] # syntax error, unexpected '='
  #   # params[:story][:url_title_track] = true if @title_scrape == params[:story][:url_title] # undefined local variable or method `params'
  # end

end
