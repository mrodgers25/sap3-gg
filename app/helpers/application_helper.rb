module ApplicationHelper
  include Pagy::Frontend

  require "fastimage"

  def admin_controller?
    controller.class.name.split("::").first == "Admin"
  end

  def pretty_date_format(date)
    date = date.to_date
    date.strftime("%b #{date.day.ordinalize} %Y")
  end

  def form_item_status_class(bool)
    bool ? 'complete-form-item' : 'incomplete-form-item'
  end

  def show_old_code
    false
  end

  def human_bool(bool)
    bool ? 'Yes' : 'No'
  end

  def valid_url?(img_url)
    sz = FastImage.size(img_url)
    if sz.nil?
      return false
    else
      return true
    end
  end

  def location_options
  hover_list_arr = Code.order("ascii(code_value)").where("code_type = 'LOCATION_CODE' and code_key != ''").pluck("code_key","code_value")

    hover_list = ""

    hover_list_arr.each do |outer|
      outer.each_with_index do |inner,ndx|
        # hover_list << "#{ndx}"
        hover_list << "(" unless ndx == 1
        hover_list << inner.to_s
        hover_list << ") "unless ndx == 1
      end
      hover_list << "<br>"
    end
    return raw hover_list
  end

  def place_category_options
    hover_list_arr = Code.order("code_value").where("code_type = 'PLACE_CATEGORY' and code_key != ''").pluck("code_key","code_value")

    hover_list = ""

    hover_list_arr.each do |outer|
      outer.each_with_index do |inner,ndx|
        # hover_list << "#{ndx}"
        hover_list << "(" unless ndx == 1
        hover_list << inner.to_s
        hover_list << ") "unless ndx == 1
      end
      hover_list << "<br>"
    end
    return raw hover_list
  end

  def story_category_options
    hover_list_arr = Code.order("code_value").where("code_type = 'STORY_CATEGORY' and code_key != ''").pluck("code_key","code_value")

    hover_list = ""

    hover_list_arr.each do |outer|
      outer.each_with_index do |inner,ndx|
        # hover_list << "#{ndx}"
        hover_list << "(" unless ndx == 1
        hover_list << inner.to_s
        hover_list << ") "unless ndx == 1
      end
      hover_list << "<br>"
    end
    return raw hover_list
  end

  def story_saved?(st_id,us_id)
    if user_signed_in?
      Usersavedstory.where("story_id = #{st_id} and user_id = #{us_id}").count == 1 ? true : false
    end
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def disabled_navigation(current_user)
    return if current_user

    'disabled'
  end
end
