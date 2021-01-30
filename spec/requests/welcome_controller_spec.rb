# frozen_string_literal: true

describe WelcomeController, type: :request do
  describe 'GET#index' do
    it 'renders root path' do
      get root_path

      expect(last_response.body).to include('Investment planning service')
    end
  end
end
