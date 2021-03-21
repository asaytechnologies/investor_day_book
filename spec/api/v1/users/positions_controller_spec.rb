# frozen_string_literal: true

describe Api::V1::Users::PositionsController do
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
      end

      context 'for request without additional fields' do
        before do
          get '/api/v1/users/positions.json', **{ access_token: access_token }
        end

        it 'returns status 200' do
          expect(last_response.status).to eq 200
        end

        %w[id selling_position amount price].each do |attr|
          it "and contains position #{attr}" do
            expect(last_response.body).to have_json_path("positions/data/0/attributes/#{attr}")
          end
        end
      end

      context 'for request with additional fields' do
        before do
          get(
            '/api/v1/users/positions.json',
            **{ access_token: access_token, fields: 'operation_date,quote_currency,security_name,security_ticker' }
          )
        end

        it 'returns status 200' do
          expect(last_response.status).to eq 200
        end

        %w[id selling_position amount price operation_date quote_currency security_name security_ticker].each do |attr|
          it "and contains position #{attr}" do
            expect(last_response.body).to have_json_path("positions/data/0/attributes/#{attr}")
          end
        end
      end
    end

    def do_request(params={})
      get '/api/v1/users/positions.json', **params
    end
  end

  describe 'POST#create' do
    it_behaves_like 'API auth without token'
    it_behaves_like 'API auth with invalid token'
    it_behaves_like 'API auth unconfirmed'

    context 'for logged user' do
      let!(:user) { create :user }
      let!(:access_token) { JwtService.new.json_response(user: user)[:access_token] }
      let!(:portfolio) { create :portfolio, user: user }
      let!(:quote) { create :quote }
      let(:valid_position_params) {
        {
          portfolio_id:   portfolio.id,
          quote_id:       quote.id,
          price:          100.0,
          amount:         2,
          operation:      0,
          operation_date: '2021-03-17'
        }
      }
      let(:request) {
        post '/api/v1/users/positions.json', **{ access_token: access_token, position: position_params, fields: '' }
      }

      context 'for unexisted portfolio' do
        let(:position_params) { valid_position_params.merge(portfolio_id: 'unexisted_id') }

        it 'does not create position' do
          expect { request }.not_to change(Users::Position, :count)
        end

        context 'in response' do
          before { request }

          it 'returns status 409' do
            expect(last_response.status).to eq 409
          end

          it 'and returns error message' do
            expect(JSON.parse(last_response.body)).to eq('errors' => ['Portfolio must exist'])
          end
        end
      end

      context 'for unexisted quote' do
        let(:position_params) { valid_position_params.merge(quote_id: 'unexisted_id') }

        it 'does not create position' do
          expect { request }.not_to change(Users::Position, :count)
        end

        context 'in response' do
          before { request }

          it 'returns status 409' do
            expect(last_response.status).to eq 409
          end

          it 'and returns error message' do
            expect(JSON.parse(last_response.body)).to eq('errors' => ['Quote must exist'])
          end
        end
      end

      context 'for valid params' do
        let(:position_params) { valid_position_params }

        it 'creates position' do
          expect { request }.to change(Users::Position, :count).by(1)
        end

        context 'in response' do
          before { request }

          it 'returns status 201' do
            expect(last_response.status).to eq 201
          end

          %w[id selling_position amount price].each do |attr|
            it "and contains position #{attr}" do
              expect(last_response.body).to have_json_path("position/data/attributes/#{attr}")
            end
          end
        end
      end
    end

    def do_request(params={})
      post '/api/v1/users/positions.json', **params
    end
  end

  describe 'DELETE#destroy' do
    it_behaves_like 'API auth without token'
    it_behaves_like 'API auth with invalid token'
    it_behaves_like 'API auth unconfirmed'

    context 'for logged user' do
      let!(:user) { create :user }
      let!(:access_token) { JwtService.new.json_response(user: user)[:access_token] }

      context 'for unexisted position' do
        let(:request) { delete '/api/v1/users/positions/unexisted.json', **{ access_token: access_token } }

        it 'does not destroy position' do
          expect { request }.not_to change(Users::Position, :count)
        end

        context 'in response' do
          before { request }

          it 'returns status 404' do
            expect(last_response.status).to eq 404
          end

          it 'and returns error message' do
            expect(JSON.parse(last_response.body)).to eq('errors' => ['Object is not found'])
          end
        end
      end

      context 'for position of another user' do
        let!(:position) { create :users_position }
        let(:request) { delete "/api/v1/users/positions/#{position.id}.json", **{ access_token: access_token } }

        it 'does not destroy position' do
          expect { request }.not_to change(Users::Position, :count)
        end

        context 'in response' do
          before { request }

          it 'returns status 404' do
            expect(last_response.status).to eq 404
          end

          it 'and returns error message' do
            expect(JSON.parse(last_response.body)).to eq('errors' => ['Object is not found'])
          end
        end
      end

      context 'for valid position' do
        let!(:portfolio) { create :portfolio, user: user }
        let!(:position) { create :users_position, portfolio: portfolio }
        let(:request) { delete "/api/v1/users/positions/#{position.id}.json", **{ access_token: access_token } }

        it 'destroys position' do
          expect { request }.to change(user.positions, :count).by(-1)
        end

        context 'in response' do
          before { request }

          it 'returns status 200' do
            expect(last_response.status).to eq 200
          end
        end
      end
    end

    def do_request(params={})
      delete '/api/v1/users/positions/unexisted.json', **params
    end
  end
end
