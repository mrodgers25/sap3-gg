require 'rails_helper'

RSpec.describe Place, type: :model do
  let(:valid_place) { FactoryBot.create(:place, address: {locality: 'San Diego, CA'}, place_status_option_id: 1) }

  it 'is valid with valid attributes' do
    expect(valid_place).to be_valid
  end

  it 'is not valid without a name' do

  end

  it 'is not valid without a place status option id' do

  end
end
