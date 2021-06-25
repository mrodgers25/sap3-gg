# frozen_string_literal: true
require 'rails_helper'

RSpec.describe '/places', type: :request do
  context 'with a logged out user' do
    it 'renders a successful response' do
      # TODO(alishaevn): figure out why places_path doesn't exist
      get '/places'
      expect(response).to be_successful
    end
  end

end
