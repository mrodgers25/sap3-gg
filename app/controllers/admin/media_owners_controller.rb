require 'csv'

class Admin::MediaOwnersController < Admin::BaseAdminController
  before_action :set_owner, except: %i[index new create]
  before_action :check_for_admin, only: [:destroy]

  def index
    @owners = MediaOwner.order(created_at: :desc)
    @owners = @owners.where('LOWER(title) ~ ?', params[:title].downcase) if params[:title].present?
    @owners = @owners.where('LOWER(url_domain) ~ ?', params[:url_domain].downcase) if params[:url_domain].present?
    @owners = @owners.where('LOWER(owner_name) ~ ?', params[:owner_name].downcase) if params[:owner_name].present?
    if params[:distribution_type].present?
      @owners = @owners.where('LOWER(distribution_type) ~ ?',
                              params[:distribution_type].downcase)
    end

    @pagy, @owners = pagy(@owners)
  end

  def new; end

  def create
    # get csv from params
    csv_text = File.read(params[:file])
    # parse csv
    csv = CSV.parse(csv_text, headers: true)
    # create records from csv
    csv.each do |row|
      MediaOwner.find_or_create_by(
        title: row[0],
        url_domain: row[1]
      )
    end

    redirect_to admin_media_owners_path, notice: 'Successfully uploaded csv.'
  rescue StandardError => e
    redirect_to new_admin_media_owner_path, alert: e
  end

  def edit; end

  def update
    if @owner.update(owner_params)
      redirect_to edit_admin_media_owner_path(@owner), notice: 'Successfully updated Media Owner.'
    else
      redirect_to edit_admin_media_owner_path(@owner), alert: 'Could not update Media Owner.'
    end
  end

  def destroy
    if @owner.destroy
      redirect_to admin_media_owners_path, notice: 'Successfully destroyed Media Owner.'
    else
      redirect_to admin_media_owners_path, alert: 'Could not destroy Media Owner.'
    end
  end

  private

  def set_owner
    @owner = MediaOwner.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to admin_media_owners_path
  end

  def owner_params
    params.require(:media_owner).permit(:title, :url_domain)
  end
end
