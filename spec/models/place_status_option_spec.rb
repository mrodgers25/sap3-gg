# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlaceStatusOption, type: :model do
  it 'is not valid without a name' do
    status = described_class.new(name: nil)
    expect(status).not_to be_valid
  end
end