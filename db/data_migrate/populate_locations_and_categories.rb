class PopulateLocationsAndCategories
  def self.run!
    locations = Code.where(code_type: 'LOCATION_CODE')
    locations.each do |loc|
      next unless loc.code_key.present?

      Location.create!(code: loc.code_key, name: loc.code_value) unless Location.exists?(code: loc.code_key)
    end

    story_categories = Code.where(code_type: 'STORY_CATEGORY')
    story_categories.each do |story_cat|
      next unless story_cat.code_key.present?

      unless StoryCategory.exists?(code: story_cat.code_key)
        StoryCategory.create!(code: story_cat.code_key,
                              name: story_cat.code_value)
      end
    end

    place_categories = Code.where(code_type: 'PLACE_CATEGORY')
    place_categories.each do |place_cat|
      next unless place_cat.code_key.present?

      unless PlaceCategory.exists?(code: place_cat.code_key)
        PlaceCategory.create!(code: place_cat.code_key,
                              name: place_cat.code_value)
      end
    end
  end
end
