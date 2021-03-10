# frozen_string_literal: true

describe Api::V1::AnalyticsController do
  describe 'GET#index' do
    it_behaves_like 'API auth without token'
    it_behaves_like 'API auth with invalid token'
    it_behaves_like 'API auth unconfirmed'

    context 'for logged user' do
      let!(:user) { create :user }
      let!(:access_token) { JwtService.new.json_response(user: user)[:access_token] }
      let!(:portfolio) { create :portfolio, user: user }

      before do
        create :users_position, portfolio: portfolio
        create :exchange_rate, rate_currency: 'RUB', rate_amount: 1, base_currency: 'RUB'
        create :exchange_rate, rate_currency: 'RUB', rate_amount: 75, base_currency: 'USD'
        create :exchange_rate, rate_currency: 'RUB', rate_amount: 90, base_currency: 'EUR'

        get '/api/v1/analytics.json', **{ access_token: access_token }
      end

      it 'returns status 200' do
        expect(last_response.status).to eq 200
      end

      %w[balance_analytics positions actives_pie_stats sector_pie_stats].each do |attr|
        it "and contains analytics for #{attr}" do
          expect(last_response.body).to have_json_path(attr)
        end
      end
    end

    def do_request(params={})
      get '/api/v1/analytics.json', **params
    end
  end
end
