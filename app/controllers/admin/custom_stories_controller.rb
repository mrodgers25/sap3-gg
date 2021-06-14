class Admin::CustomStoriesController < Admin::BaseAdminController
  before_action :set_story, only: [:edit, :update, :destroy_image, :list_editor, :update_list, :review, :review_update]
  before_action :get_locations_and_categories, only: [:new, :edit]

  def new
    @story = CustomStory.new
    @story.build_external_image
    @story.build_list
  end

  def create
    begin
      @story = CustomStory.create!(story_params)
      redirect_to list_editor_admin_custom_story_path(@story), notice: 'Story was successfully created.'
    rescue => e
      redirect_to new_admin_custom_story_path, alert: e
    end
  end

    def edit
    @story.build_external_image if @story.external_image.blank?
  end

  def update
    begin
      @story.update!(story_params)

      if params[:commit] == 'Go to List Editor'
        redirect_to list_editor_admin_custom_story_path(@story)
      else
        redirect_to admin_stories_path, notice: 'Story was successfully updated.'
      end
    rescue => e
      redirect_to edit_admin_custom_story_path(@story), alert: e
    end
  end

  def destroy_image
    if params[:image_type] == 'internal' && @story.internal_image.attached?
      @story.internal_image.purge
      @story.update(internal_image_height: 0, internal_image_width: 0)
      render json: { success: true, message: 'Image was successfully removed.' }
    elsif params[:image_type] == 'external' && @story.external_image.present?
      @story.external_image.destroy!
      render json: { success: true, message: 'Image was successfully removed.' }
    else
      render json: { success: false, message: 'Error occured' }
    end
  end

  def list_editor
    params[:url_title] ||= session[:url_title]
    session[:url_title] = params[:url_title]

    params[:story_type] ||= session[:story_type]
    session[:story_type] = params[:story_type]

    # stories that are currently on the list
    @list_items = @story.list_items.includes(:story).order(:position, :created_at)

    # stories to search
    @published_items = []

    if params[:url_title].present? || params[:story_type].present?
      @published_items = PublishedItem.joins("
        INNER JOIN stories ON (publishable_type = 'Story' AND stories.id = publishable_id)
        LEFT JOIN urls ON urls.story_id = stories.id
      ").select(
        'published_items.*',
        'stories.type AS story_type',
        "
          CASE
            WHEN stories.story_year > 0 AND stories.story_month > 0 AND stories.story_date > 0
            THEN TO_DATE(CONCAT(stories.story_year::TEXT, '-', stories.story_month::TEXT, '-', stories.story_date::TEXT), 'YYYY-MM-DD')
            WHEN stories.story_year > 0 AND stories.story_month > 0
            THEN TO_DATE(CONCAT(stories.story_year::TEXT, '-', stories.story_month::TEXT), 'YYYY-MM')
            ELSE null
          END AS story_date_combined
        "
      )
      @published_items = @published_items.where(state: 'displaying')
      @published_items = @published_items.where.not(publishable_id: @list_items.pluck(:story_id))
      @published_items = @published_items.where("LOWER(urls.url_title) ~ ?", params[:url_title].downcase) if params[:url_title].present?
      @published_items = @published_items.where("stories.type ~ ?", params[:story_type]) if params[:story_type].present?
      @published_items = @published_items.distinct
      @published_items = @published_items.order(story_date_combined: :desc)
    end

    if @published_items.present?
      @pagy, @published_items = pagy(@published_items, items: 5)
    else
      @pagy = nil
    end
  end

  def update_list
    begin
      case params[:action_type]
      when 'remove'
        @list_item = @story.list_items.find(params[:list_item_id])
        @list_item.destroy!
      when 'add'
        # Another fail safe but this should already be created when the new route is visited
        unless @story.list
          @story.build_list
          @story.save
        end

        ListItem.create!(list_id: @story.list.id, story_id: params[:story_id])
      end

      redirect_to list_editor_admin_custom_story_path(@story), notice: 'List was updated.'
    rescue => e
      redirect_to list_editor_admin_custom_story_path(@story), alert: "List was not updated. Error: #{e}"
    end
  end

  def review
    @list_items = @story.list_items
  end

  def review_update
    if @story.update(review_update_params)
      redirect_to review_admin_custom_story_path(@story)
    else
      redirect_to review_admin_custom_story_path(@story), notice: 'Story failed to be updated.'
    end
  end

  private

  def set_story
    begin
      @story = CustomStory.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_stories_path, alert: "Custom Story not found"
    end
  end

  def get_locations_and_categories
    @locations        = Location.order("ascii(name)")
    @place_categories = PlaceCategory.order(:name)
    @story_categories = StoryCategory.order(:name)
  end

  def story_params
    params.require(:custom_story).permit(
      :editor_tagline,
      :author,
      :hashtags,
      :outside_usa,
      :state,
      :story_year,
      :story_month,
      :story_date,
      :data_entry_begin_time,
      :data_entry_user,
      :desc_length,
      :custom_body,
      :internal_image,
      :internal_image_width,
      :internal_image_height,
      :savable,
      location_ids: [],
      story_category_ids: [],
      place_category_ids: [],
      external_image_attributes: [
        :src_url, :width, :height
      ]
    )
  end

  def review_update_params
    params.require(:custom_story).permit(:editor_tagline, :savable)
  end
end
