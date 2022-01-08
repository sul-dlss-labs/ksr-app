# frozen_string_literal: true

RSpec.describe SearchController do
  describe 'SEARCH index' do
    it 'shows the bento search page' do
      get :index
      expect(response.status).to eq 200
    end
  end
end
