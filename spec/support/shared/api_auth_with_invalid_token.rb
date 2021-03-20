# frozen_string_literal: true

shared_examples_for 'API auth with invalid token' do
  let!(:user) { create :user }
  let!(:access_token) { JwtService.new.json_response(user: user)[:access_token] }
  before { do_request(access_token: "#{access_token}1") }

  it 'returns status 401' do
    expect(last_response.status).to eq 401
  end

  it 'and contains error message' do
    expect(JSON.parse(last_response.body)).to eq('errors' => 'Signature verification error')
  end
end
