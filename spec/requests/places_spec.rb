# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/admin/places', type: :request do
  context 'with a logged out user' do
    before do
      get admin_places_path
    end

    it 'is inaccessible' do
      expect(response.status).to eq(302)
    end

    it 'redirects to the log in screen' do
      expect(response.body).to eq('<html><body>You are being <a href="http://www.example.com/users/sign_in">redirected</a>.</body></html>')
    end
  end

  context 'with a logged in user' do
    let(:user) { create(:user) }

    before do
      sign_in user
      get admin_places_path
    end

    it 'is inaccessible' do
      expect(response.status).to eq(302)
    end

    it 'redirects to the home screen' do
      expect(response.body).to eq('<html><body>You are being <a href="http://www.example.com/">redirected</a>.</body></html>')
    end
  end

  context 'with a logged in admin user' do
    let(:admin_user) { create(:admin_user) }

    before do
      sign_in admin_user
      get admin_places_path
    end

    it 'renders a successful response' do
      expect(response).to be_successful
    end

    it 'loads the places page' do
      expect(response.body).to include('<h4><i class="fas fa-map-marker-alt mr-1"></i> Places</h4>')
    end
  end
end
