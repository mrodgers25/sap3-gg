# frozen_string_literal: true

module Admin
  class UsersController < Admin::BaseAdminController
    before_action :set_user, except: %i[index bulk_update]
    before_action :check_for_admin, only: %i[update destroy bulk_update]

    def index
      @users = User.order(created_at: :desc)
      @users = @users.where('LOWER(first_name) ~ ?', params[:first_name].downcase) if params[:first_name].present?
      @users = @users.where('LOWER(last_name) ~ ?', params[:last_name].downcase) if params[:last_name].present?
      @users = @users.where('LOWER(email) ~ ?', params[:email].downcase) if params[:email].present?
      if params[:city_preference].present?
        @users = @users.where('LOWER(city_preference) ~ ?',
                              params[:city_preference].downcase)
      end
      @users = @users.where(role: params[:role]) if params[:role].present?
      @users = @users.where(confirmed_at: nil) if params[:status].present? && params[:status] == 'unconfirmed'

      @pagy, @users = pagy(@users)
    end

    def edit; end

    def update
      if @user.update(user_params)
        redirect_to edit_admin_user_path(@user), notice: 'Successfully updated User.'
      else
        redirect_to edit_admin_user_path(@user), alert: 'Could not update User.'
      end
    end

    def destroy
      if @user.destroy
        redirect_to admin_users_path, notice: 'Successfully destroyed User.'
      else
        redirect_to admin_users_path, alert: 'Could not destroy User.'
      end
    end

    def bulk_update
      @users = User.where(id: bulk_update_params[:ids])
      count  = @users.size

      if @users.present?
        begin
          case bulk_update_params[:update_type]
          when 'confirm_selected'
            @users.each { |user| user.update(confirmed_at: Time.zone.now) }
            action_text = 'confirmed'
          when 'delete_selected'
            @users.destroy_all
            action_text = 'deleted'
          end

          redirect_to admin_users_path, notice: "#{count} users #{action_text}."
        rescue StandardError => e
          redirect_to admin_users_path, alert: e
        end
      else
        redirect_to admin_users_path, alert: 'No selection was made.'
      end
    end

    private

    def set_user
      @user = User.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_users_path
    end

    def user_params
      params.require(:user).permit(:first_name, :last_name, :email, :role, :city_preference)
    end

    def bulk_update_params
      params.permit(:update_type, ids: [])
    end
  end
end
