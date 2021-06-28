# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StoryPlace, type: :model do
  it 'is not valid without a story' do
    story = described_class.new(story_id: nil)
    expect(story).not_to be_valid
  end

  it 'is not valid without a place' do
    place = described_class.new(place_id: nil)
    expect(place).not_to be_valid
  end
end
