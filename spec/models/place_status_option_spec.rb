require 'rails_helper'

RSpec.describe PlaceStatusOption, type: :model do
  it 'is not valid without a name' do
    status = PlaceStatusOption.new(name: nil)
    expect(status).not_to be_valid
  end
end
