# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  require 'fastimage'

  def admin_controller?
    controller.class.name.split('::').first == 'Admin'
  end

  def pretty_date_format(date)
    date = date.to_date
    date.strftime("%b #{date.day.ordinalize} %Y")
  end

  def form_item_status_class(bool)
    bool ? '' : 'incomplete-form-item'
  end

  def bg_yellow_class(bool)
    bool ? 'bg-warning' : ''
  end

  def published_item_state_color(state)
    case state
    when 'displaying'
      'text-success'
    when 'queued'
      'text-warning'
    when 'newsfeed'
      'text-primary'
    else
      ''
    end
  end

  def story_state_color(state)
    case state
    when 'no_status'
      'text-primary'
    when 'needs_review'
      'text-warning'
    when 'do_not_publish'
      'text-danger'
    when 'completed'
      'text-success'
    when 'removed_from_public'
      'text-secondary'
    else
      ''
    end
  end

  def colored_icon_for_story_type(story_type)
    case story_type
    when 'MediaStory'
      'far fa-newspaper text-dark'
    when 'VideoStory'
      'fab fa-youtube text-danger'
    when 'CustomStory'
      'fas fa-asterisk text-primary'
    else
      ''
    end
  end

  def show_old_code
    false
  end

  def human_bool(bool)
    bool ? 'Yes' : 'No'
  end

  def valid_url?(img_url)
    sz = FastImage.size(img_url)
    !sz.nil?
  end

  def location_options
    hover_list_arr = Code.order('ascii(code_value)').where("code_type = 'LOCATION_CODE' and code_key != ''").pluck(
      'code_key', 'code_value'
    )

    hover_list = ''

    hover_list_arr.each do |outer|
      outer.each_with_index do |inner, ndx|
        # hover_list << "#{ndx}"
        hover_list << '(' unless ndx == 1
        hover_list << inner.to_s
        hover_list << ') ' unless ndx == 1
      end
      hover_list << '<br>'
    end
    raw hover_list
  end

  def place_category_options
    hover_list_arr = Code.order('code_value').where("code_type = 'PLACE_CATEGORY' and code_key != ''").pluck('code_key',
                                                                                                             'code_value')

    hover_list = ''

    hover_list_arr.each do |outer|
      outer.each_with_index do |inner, ndx|
        # hover_list << "#{ndx}"
        hover_list << '(' unless ndx == 1
        hover_list << inner.to_s
        hover_list << ') ' unless ndx == 1
      end
      hover_list << '<br>'
    end
    raw hover_list
  end

  def story_category_options
    hover_list_arr = Code.order('code_value').where("code_type = 'STORY_CATEGORY' and code_key != ''").pluck('code_key',
                                                                                                             'code_value')

    hover_list = ''

    hover_list_arr.each do |outer|
      outer.each_with_index do |inner, ndx|
        # hover_list << "#{ndx}"
        hover_list << '(' unless ndx == 1
        hover_list << inner.to_s
        hover_list << ') ' unless ndx == 1
      end
      hover_list << '<br>'
    end
    raw hover_list
  end

  def story_saved?(st_id, us_id)
    Usersavedstory.where("story_id = #{st_id} and user_id = #{us_id}").count == 1 if user_signed_in?
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
