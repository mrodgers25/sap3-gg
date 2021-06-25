class Admin::PlacesController < Admin::BaseAdminController
  before_action :set_place, except: %i[index new create]
  before_action :check_for_admin, only: :destroy
  
  def index
    @places = Place.order(created_at: :desc)
    @pagy, @places = pagy(@places)
  end

  def show
    @comments = Comment.where(reference: "place", reference_id: @place.id)
  end

  def new
    @place = Place.new
    @place.build_address
  end

  def create
    @place = Place.new(place_params)
    if @place.save
      if params[:place][:story_id]
        StoryPlace.create(story_id: params[:place][:story_id], place_id: @place.id)
        redirect_to edit_admin_media_story_path(params[:place][:story_id]), notice: "Successfully created #{@place.name}"
      else 
        redirect_to admin_place_path(@place), notice: "Successfully created #{@place.name}"
      end   
    else
      redirect_to new_admin_place_path, alert: 'Could not create Place.'
    end
  end

  def edit 
  end

  def update
    if @place.update(place_params)
      redirect_to admin_place_path(@place), notice: 'Successfully updated Place.'
    else
      redirect_to admin_place_path(@place), alert: 'Could not update Place.'
    end
  end

  def destroy
    if @place.destroy
      redirect_to admin_places_path, notice: 'Successfully destroyed Place.'
    else
      redirect_to admin_places_path, alert: 'Could not destroy Place.'
    end
  end

  private

  def set_place
    @place = Place.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_places_path
  end

  def place_params
    params.require(:place).permit!
  end

end