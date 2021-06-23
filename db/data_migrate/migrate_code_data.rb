class MigrateCodeData
  def self.run!
    Story.all.each do |story|
      # locations
      next unless story.location_code.present?

      loc_codes = story.location_code.split(',')
      loc_codes.each do |loc_code|
        location = Location.where(code: loc_code).first
        next unless location

        story.locations << location
      end

      # place categories
      next unless story.place_category.present?

      p_cat_codes = story.place_category.split(',')
      p_cat_codes.each do |p_code|
        place_category = PlaceCategory.where(code: p_code).first
        next unless place_category

        story.place_categories << place_category
      end

      # story categories
      next unless story.story_category.present?

      s_cat_codes = story.story_category.split(',')
      s_cat_codes.each do |s_code|
        story_category = StoryCategory.where(code: s_code).first
        next unless story_category

        story.story_categories << story_category
      end
    end
  end
end
