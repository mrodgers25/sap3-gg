module ApplicationHelper
  include Pagy::Frontend

  require "fastimage"

  def admin_controller?
    controller.class.name.split("::").first=="Admin"
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

  # def location_options
  #   location_options = "<strong>AZ-Phoenix (PHX)</strong>​<br>
  #                       ​<strong>CA-San Francisco (SF)</strong>​<br>
  #                       ​<strong>CA-Los Angeles (LA)</strong>​<br>
  #                       ​<strong>CA-San Diego (SD)</strong>​<br>
  #                       ​<strong>DC-Washington (DC)</strong>​<br>
  #                       <strong>IL-Chicago (CHI)</strong><br>
  #                       ​<strong>LA-New Orleans (NOLA)</strong><br>
  #                       ​<strong>MA-Boston (BOS)</strong>​<br>
  #                       ​<strong>NV-Las Vegas (NV)</strong>​<br>
  #                       ​<strong>NY-New York City (NYC)</strong>​<br>
  #                       ​<strong>OR-Portland (PORT)</strong><br>
  #                       ​<strong>PA-Philadelphia (PHIL)</strong><br>
  #                       ​<strong>TX-Austin (AUST)</strong>​<br>
  #                       ​<strong>WA-Seattle (SEA)</strong>​<br>"
  # end

  # def place_category_options
  #   place_category_options = "​<strong>(A) Attraction</strong>​<br>
  #                       ​<strong>(FD) Food & Drink</strong>​<br>
  #                       ​<strong>(L) Lodging</strong>​<br>
  #                       ​<strong>(SH) Shopping</strong>​<br>
  #                       ​<strong>(SR) Service</strong>​<br>
  #                       ​<strong>(SP) Sport or Activity</strong>​"
  # end

  # def story_category_options
  #   story_category_options = "<strong>(EP) Editor Picks</strong><br>
  #                       ​<strong>(UN) More Unique Than Usual</strong>​<br>
  #                       ​<strong>(TL) Top/Best/Coolest Lists</strong>​<br>
  #                       ​<strong>(SI) Suggested Itineraries</strong>​<br>
  #                       ​<strong>(IA) Industry Awards</strong>​<br>
  #                       ​<strong>(RO) Romance</strong>​<br>
  #                       ​<strong>(FF) Family Friendly</strong>​<br>
  #                       ​<strong>(PF) Pet Friendly</strong>​"

  # end


  # added these three methods for devise access by login modal
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
