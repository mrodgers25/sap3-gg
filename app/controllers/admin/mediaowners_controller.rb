class Admin::MediaownersController < Admin::BaseAdminController
  before_action :set_owner, except: :index
  before_action :check_for_admin, only: [:destroy]

  def index
    @owners = Mediaowner.order(created_at: :desc)
    @owners = @owners.where("LOWER(title) ~ ?", params[:title].downcase) if params[:title].present?
    @owners = @owners.where("LOWER(url_domain) ~ ?", params[:url_domain].downcase) if params[:url_domain].present?
    @owners = @owners.where("LOWER(owner_name) ~ ?", params[:owner_name].downcase) if params[:owner_name].present?
    @owners = @owners.where("LOWER(distribution_type) ~ ?", params[:distribution_type].downcase) if params[:distribution_type].present?

    @pagy, @owners = pagy(@owners)
  end

  def edit
  end

  def update
    if @owner.update(owner_params)
      redirect_to edit_admin_mediaowner_path(@owner), notice: "Successfully updated Media Owner."
    else
      redirect_to edit_admin_mediaowner_path(@owner), alert: "Could not update Media Owner."
    end
  end

  def destroy
    if @owner.destroy
      redirect_to admin_mediaowners_path, notice: "Successfully destroyed Media Owner."
    else
      redirect_to admin_mediaowners_path, alert: "Could not destroy Media Owner."
    end
  end

  private

  def set_owner
    begin
      @owner = Mediaowner.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_mediaowners_path
    end
  end

  def owner_params
    params.require(:mediaowner).permit(:title, :url_full, :url_domain, :owner_name, :media_type, :distribution_type, :publication_name, :paywall_yn, :content_frequency_time, :content_frequency_other, :content_frequency_guide, :nextissue_yn)
  end
end
