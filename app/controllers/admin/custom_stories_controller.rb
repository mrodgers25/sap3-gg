class Admin::CustomStoriesController < Admin::BaseAdminController
  before_action :set_story, only: [:edit, :update, :destroy_image, :list_edit, :list_editor, :update_list, :review, :review_update]
  before_action :get_locations_and_categories, only: [:new, :edit]

  def new
    @story = CustomStory.new
    @story.build_external_image
    @story.build_list
  end

  def create
    begin
      @story = CustomStory.create!(story_params)
      create_associations_from_params!

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
      create_associations_from_params!

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
    if params[:image_type] == 'internal' && @story.internal_images.attached?
      @story.internal_images.purge
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
    @list_items = @story.sorted_list_items

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

  def list_edit
    @list_item = @story.list_items.find(params[:list_item_id])
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
      when 'update'
        @list_item = @story.list_items.find(params[:list_item_id])
        @list_item.update(list_item_params)
        # resequence other list items for story
        set_position_and_resequence
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
      :internal_image_width,
      :internal_image_height,
      :savable,
      internal_images: [],
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

  def list_item_params
    params.require(:list_item).permit(:position)
  end

  def set_position_and_resequence
    new_position = @list_item.position
    old_position = params[:old_position].to_i

    if new_position && old_position && (new_position <= old_position)
      @list_item.update(position: (new_position - 1))
    end
    # resort all other positions
    sorted_by_position = @story.list_items.where.not(position: nil).order(position: :asc, created_at: :desc)
    sorted_by_position.each_with_index do |item, index|
      new_position = index + 1
      item.update(position: new_position)
    end
  end

  def create_associations_from_params!
    new_locations        = Location.where(id: story_params[:location_ids])
    new_story_categories = StoryCategory.where(id: story_params[:story_category_ids])
    new_place_categories = PlaceCategory.where(id: story_params[:place_category_ids])

    @story.locations        = new_locations
    @story.story_categories = new_story_categories
    @story.place_categories = new_place_categories

    @story.save!
  end
end
