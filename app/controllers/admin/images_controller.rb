class Admin::ImagesController < Admin::BaseAdminController
  before_action :set_image, except: :index
  before_action :check_for_admin, only: :destroy

  def index
    @images = Image.order(created_at: :desc)
    @images = @images.where('LOWER(src_url) ~ ?', params[:search].downcase) if params[:search].present?

    @pagy, @images = pagy(@images)
  end

  def edit; end

  def update
    if @image.update(image_params)
      redirect_to edit_admin_image_path(@image), notice: 'Successfully updated Image.'
    else
      redirect_to edit_admin_image_path(@image), alert: 'Could not update Image.'
    end
  end

  def destroy
    if @image.destroy
      redirect_to admin_images_path, notice: 'Successfully destroyed Image.'
    else
      redirect_to admin_images_path, alert: 'Could not destroy Image.'
    end
  end

  private

  def set_image
    @image = Image.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_images_path
  end

  def image_params
    params.require(:image).permit(:src_url, :alt_text, :image_width, :image_height, :manual_enter)
  end
end
