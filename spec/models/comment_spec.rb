require 'rails_helper'

RSpec.describe Comment, type: :model do
  it "is not valid without a user" do
    user = Comment.new(user_id: nil)
    expect(user).to_not be_valid
  end

  it "is not valid without a note" do
    note = Comment.new(note: nil)
    expect(note).to_not be_valid
  end
end
