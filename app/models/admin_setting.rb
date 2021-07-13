# frozen_string_literal: true

class AdminSetting < ApplicationRecord
  def self.newsfeed_display_limit
    # AdminSetting.first.newsfeed_display_limit
  end

  def self.filtered_display_limit
    # AdminSetting.first.filtered_display_limit
  end

  def self.newsfeed_daily_post_count
    # AdminSetting.first.newsfeed_daily_post_count
  end
end
