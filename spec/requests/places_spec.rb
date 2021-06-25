# frozen_string_literal: true

require 'rails_helper'

RSpec.describe '/admin/places', type: :request do
  context 'with a logged out user' do
    it 'redirects to the log in screen' do
      get admin_places_path
      expect(response.status).to eq(302)
    end
  end

  context 'with a logged in user' do
    let(:user) { FactoryBot.create(:user) }

    before do
      # TODO(alishaevn): figure out why the user isn't being signed in
      login_as user
    end

    xit 'redirects to the log in screen' do
      get admin_places_path
      expect(response.status).to eq(302)
    end
  end

  context 'with a logged in admin user' do
    let(:admin_user) { FactoryBot.create(:admin_user) }

    before do
      # TODO(alishaevn): figure out why the user isn't being signed in
      login_as admin_user
    end

    xit 'renders a successful response' do
      get admin_places_path
      expect(response).to be_successful
    end
  end
end
