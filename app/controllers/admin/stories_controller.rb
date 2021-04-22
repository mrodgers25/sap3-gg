class Admin::StoriesController < Admin::BaseAdminController

  def index
     # database dropdown data
    @locations        = Location.order("ascii(name)")
    @place_categories = PlaceCategory.order(:name)
    @story_categories = StoryCategory.order(:name)

    @stories = Story.joins(:urls)
    @stories = @stories.where("LOWER(type) ~ ?", params[:type].downcase) if params[:type].present?
    @stories = @stories.where("LOWER(urls.url_title) ~ ?", params[:url_title].downcase) if params[:url_title].present?
    @stories = @stories.where("LOWER(urls.url_desc) ~ ?", params[:url_desc].downcase) if params[:url_desc].present?
    @stories = @stories.where(state: params[:state]) if params[:state].present?
    @stories = @stories.joins(:locations).where(locations: { id: params[:location_id] }) if params[:location_id].present?
    @stories = @stories.joins(:place_categories).where(place_categories: { id: params[:place_category_id] }) if params[:place_category_id].present?
    @stories = @stories.joins(:story_categories).where(story_categories: { id: params[:story_category_id] }) if params[:story_category_id].present?

    if params[:order_by].present?
      col = params[:order_by].split(' ').first
      dir = params[:order_by].split(' ').last
      @stories = @stories.order(col => dir)
    else
      @stories = @stories.order('created_at DESC')
    end

    @pagy, @stories = pagy(@stories)
  end
end
