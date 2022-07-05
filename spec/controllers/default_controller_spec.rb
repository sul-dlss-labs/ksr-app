# frozen_string_literal: true

RSpec.describe DefaultController do
  describe 'GET index' do
    it 'shows the home page' do
      get :index
      expect(response).to have_http_status :ok
    end
  end
end
