# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  it 'is not valid without a user' do
    user = described_class.new(user_id: nil)
    expect(user).not_to be_valid
  end

  it 'is not valid without a note' do
    note = described_class.new(note: nil)
    expect(note).not_to be_valid
  end
end