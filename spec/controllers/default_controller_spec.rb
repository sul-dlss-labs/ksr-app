# frozen_string_literal: true

RSpec.describe DefaultController do
  describe 'GET index' do
    it 'shows the home page' do
      get :index
      expect(response.status).to eq 200
    end
  end
end
