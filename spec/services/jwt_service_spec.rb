# frozen_string_literal: true

RSpec.describe JwtService, type: :service do
  let(:service) { described_class.new }

  describe '.initialize' do
    it 'class JWT_TTL constant' do
      expect(JwtService::JWT_TTL).not_to eq nil
    end
  end

  describe '.json_response' do
    let!(:user) { create :user }
    let(:response) { service.json_response(user: user) }

    it 'returns access_token', :aggregate_failures do
      expect(response[:access_token]).not_to eq nil
      expect(response[:access_token].is_a?(String)).to eq true
    end

    it 'and returns expiration information', :aggregate_failures do
      expect(response[:expires_at]).not_to eq nil
      expect(response[:expires_at].is_a?(Integer)).to eq true
    end
  end

  describe '.decode' do
    let!(:user) { create :user }
    let(:response) { service.json_response(user: user) }
    let(:decode) { service.decode(access_token: response[:access_token]) }

    it 'decodes information from token' do
      expect(decode).not_to eq nil
    end

    it 'contains user_id' do
      expect(decode['user_id']).to eq user.id
    end

    it 'and contains exp' do
      expect(decode['exp']).not_to eq nil
    end
  end

  describe '.encode' do
    let!(:user) { create :user }
    let(:encode) { service.send(:encode, user_id: user.id) }

    it 'returns array' do
      expect(encode.is_a?(Array)).to eq true
    end

    it 'contains token' do
      expect(encode[0].is_a?(String)).to eq true
    end

    it 'and contains expiration time' do
      expect(encode[1].is_a?(Integer)).to eq true
    end
  end

  describe '.jwt_secret' do
    it 'returns secret key for app' do
      expect(service.send(:jwt_secret)).to eq Rails.application.credentials.secret_key_base
    end
  end
end
