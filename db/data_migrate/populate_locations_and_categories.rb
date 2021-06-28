# frozen_string_literal: true

class PopulateLocationsAndCategories
  def self.run!
    locations = Code.where(code_type: 'LOCATION_CODE')
    locations.each do |loc|
      next if loc.code_key.blank?

      Location.create!(code: loc.code_key, name: loc.code_value) unless Location.exists?(code: loc.code_key)
    end

    story_categories = Code.where(code_type: 'STORY_CATEGORY')
    story_categories.each do |story_cat|
      next if story_cat.code_key.blank?

      unless StoryCategory.exists?(code: story_cat.code_key)
        StoryCategory.create!(code: story_cat.code_key,
                              name: story_cat.code_value)
      end
    end

    place_categories = Code.where(code_type: 'PLACE_CATEGORY')
    place_categories.each do |place_cat|
      next if place_cat.code_key.blank?

      unless PlaceCategory.exists?(code: place_cat.code_key)
        PlaceCategory.create!(code: place_cat.code_key,
                              name: place_cat.code_value)
      end
    end
  end
end
