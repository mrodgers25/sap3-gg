  class StoryPagesController < ApplicationController
    before_action :set_story

    layout "application_v2_no_nav"

    def show
    end

    private

    def set_story
      @story = Story.find_by(permalink: (params[:permalink]))
    end
  end
