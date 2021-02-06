# frozen_string_literal: true

describe SitemapsController, type: :request do
  describe 'GET#index' do
    it 'renders sitemap index page' do
      get sitemap_path, format: :xml

      expect(last_response).to be_successful
    end
  end
end
