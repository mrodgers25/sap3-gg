  class StoryPagesController < ApplicationController
    layout "application_v2_no_nav"

    def show
      @story = Story.find_by(permalink: (params[:permalink]))
      @urls = @story.urls
      @images = @urls.first.images
      @publisher = @urls.first.mediaowner.nil? ? "None" : @urls.first.mediaowner
      @description = @urls.first.url_desc
      @full_storypage_url = "http://www.storiesaboutplaces.com/story_pages/#{@story.permalink}"
      render template: "story_pages/show.html.erb"
    end

    def story_params
      params.require(:story).permit(
        :media_id, :scraped_type, :story_type, :author, :outside_usa, :permalink, :story_year, :story_month, :story_date, :sap_publish_date,
        :editor_tagline, :raw_author_scrape, :raw_story_year_scrape,
        :raw_story_month_scrape, :raw_story_date_scrape, :data_entry_begin_time, :data_entry_user, :story_complete,
        :release_seq,
        :location_ids => [],
        :place_category_ids => [],
        :story_category_ids => [],
        urls_attributes: [
          :id, :url_type, :url_full, :url_title, :url_desc, :url_keywords, :url_domain, :primary, :story_id,
          :url_title_track, :url_desc_track, :url_keywords_track,
          :raw_url_title_scrape, :raw_url_desc_scrape, :raw_url_keywords_scrape,
              images_attributes: [:id, :src_url, :alt_text, :image_data, :manual_url, :image_width, :image_height, :manual_enter]])
    end


  end
