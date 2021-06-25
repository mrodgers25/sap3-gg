require 'rails_helper'

RSpec.describe StoryPlace, type: :model do
  it 'is not valid without a story' do
    story = StoryPlace.new(story_id: nil)
    expect(story).not_to be_valid
  end

  it 'is not valid without a place' do
    place = StoryPlace.new(place_id: nil)
    expect(place).not_to be_valid
  end
end
