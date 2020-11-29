# frozen_string_literal: true

describe Portfolios::CreateService, type: :service do
  subject(:service_call) { described_class.call(args) }

  let!(:user) { create :user }
  let(:args) { { user: user, name: 'Portfolio' } }

  before do
    allow(Portfolios::Cashes::CreateService).to receive(:call)
  end

  describe '.call' do
    it 'succeeds' do
      expect(service_call.success?).to eq true
    end

    it 'and creates portfolio' do
      expect { service_call }.to change(user.portfolios, :count).by(1)
    end

    it 'and calls cashes create service' do
      service_call

      expect(Portfolios::Cashes::CreateService).to have_received(:call)
    end
  end
end
