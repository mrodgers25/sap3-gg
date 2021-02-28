require 'csv'

class Admin::MediaOwnersController < Admin::BaseAdminController
  before_action :set_owner, except: [:index, :new, :create]
  before_action :check_for_admin, only: [:destroy]

  def index
    @owners = MediaOwner.order(created_at: :desc)
    @owners = @owners.where("LOWER(title) ~ ?", params[:title].downcase) if params[:title].present?
    @owners = @owners.where("LOWER(url_domain) ~ ?", params[:url_domain].downcase) if params[:url_domain].present?
    @owners = @owners.where("LOWER(owner_name) ~ ?", params[:owner_name].downcase) if params[:owner_name].present?
    @owners = @owners.where("LOWER(distribution_type) ~ ?", params[:distribution_type].downcase) if params[:distribution_type].present?

    @pagy, @owners = pagy(@owners)
  end

  def new
  end

  def create
    begin
      # get csv from params
      csv_text = File.read(params[:file])
      # parse csv
      csv = CSV.parse(csv_text, headers: true)
      # create records from csv
      csv.each do |row|
        MediaOwner.find_or_create_by!(
          title: row.fetch('title'),
          url_domain: row.fetch('url_domain')
        )
      end

      redirect_to admin_media_owners_path, notice: "Successfully uploaded csv."
    rescue => e
      redirect_to new_admin_media_owner_path, alert: e
    end
  end

  def edit
  end

  def update
    if @owner.update(owner_params)
      redirect_to edit_admin_media_owner_path(@owner), notice: "Successfully updated Media Owner."
    else
      redirect_to edit_admin_media_owner_path(@owner), alert: "Could not update Media Owner."
    end
  end

  def destroy
    if @owner.destroy
      redirect_to admin_media_owners_path, notice: "Successfully destroyed Media Owner."
    else
      redirect_to admin_media_owners_path, alert: "Could not destroy Media Owner."
    end
  end

  private

  def set_owner
    begin
      @owner = MediaOwner.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_media_owners_path
    end
  end

  def owner_params
    params.require(:media_owner).permit(:title, :url_domain)
  end
end
