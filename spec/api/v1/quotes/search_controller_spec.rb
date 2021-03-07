# frozen_string_literal: true

describe Api::V1::Quotes::SearchController do
  describe 'GET#index' do
    it_behaves_like 'API auth without token'
    it_behaves_like 'API auth with invalid token'
    it_behaves_like 'API auth unconfirmed'

    context 'for logged user' do
      let!(:user) { create :user }
      let!(:access_token) { JwtService.new.json_response(user: user)[:access_token] }
      let!(:share) { create :share, ticker: 'F' }

      before do
        create :quote, security: share

        get '/api/v1/quotes/search.json', **{ access_token: access_token, query: 'F' }
      end

      it 'returns status 200' do
        expect(last_response.status).to eq 200
      end

      %w[id security_type security_name security_ticker price].each do |attr|
        it "and contains quote #{attr}" do
          expect(last_response.body).to have_json_path("quotes/data/0/attributes/#{attr}")
        end
      end
    end

    def do_request(params={})
      get '/api/v1/quotes/search.json', **params
    end
  end
end
