# frozen_string_literal: true

module Admin
  class StoryCategoriesController < Admin::BaseAdminController
    before_action :set_category, except: %i[index new create]
    before_action :check_for_admin, only: :destroy

    def index
      @categories = StoryCategory.order(created_at: :desc)
      @categories = @categories.where('LOWER(code) ~ ?', params[:code].downcase) if params[:code].present?
      @categories = @categories.where('LOWER(name) ~ ?', params[:name].downcase) if params[:name].present?

      @pagy, @categories = pagy(@categories)
    end

    def new
      @category = StoryCategory.new
    end

    def create
      @category = StoryCategory.new(category_params)

      if @category.save
        redirect_to admin_story_categories_path, notice: 'Successfully created Story Category.'
      else
        redirect_to admin_story_categories_path, alert: 'Could not create Story Category.'
      end
    end

    def edit; end

    def update
      if @category.update(category_params)
        redirect_to edit_admin_story_category_path(@category), notice: 'Successfully updated Story Category.'
      else
        redirect_to edit_admin_story_category_path(@category), alert: 'Could not update Story Category.'
      end
    end

    def destroy
      if @category.destroy
        redirect_to admin_story_categories_path, notice: 'Successfully destroyed Story Category.'
      else
        redirect_to admin_story_categories_path, alert: 'Could not destroy Story Category.'
      end
    end

    private

    def set_category
      @category = StoryCategory.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_story_categories_path
    end

    def category_params
      params.require(:story_category).permit(:code, :name)
    end
  end
end
