# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Place, type: :model do
  it { is_expected.to belong_to(:location) }

  it { is_expected.to accept_nested_attributes_for(:location) }

  it { is_expected.to have_many(:story_places).dependent(:destroy) }
  it { is_expected.to have_many(:stories).through(:story_places) }

  it { is_expected.to validate_presence_of(:name) }

end
