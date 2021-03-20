# frozen_string_literal: true

describe Api::V1::PortfoliosController do
  describe 'GET#index' do
    it_behaves_like 'API auth without token'
    it_behaves_like 'API auth with invalid token'
    it_behaves_like 'API auth unconfirmed'

    context 'for logged user' do
      let!(:user) { create :user }
      let!(:access_token) { JwtService.new.json_response(user: user)[:access_token] }

      before do
        create :portfolio, user: user

        get '/api/v1/portfolios.json', **{ access_token: access_token }
      end

      it 'returns status 200' do
        expect(last_response.status).to eq 200
      end

      %w[id name currency broker_name created_at].each do |attr|
        it "and contains portfolio #{attr}" do
          expect(last_response.body).to have_json_path("portfolios/data/0/attributes/#{attr}")
        end
      end
    end

    def do_request(params={})
      get '/api/v1/portfolios.json', **params
    end
  end
end
