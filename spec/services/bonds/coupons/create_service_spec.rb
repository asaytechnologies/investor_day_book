# frozen_string_literal: true

RSpec.describe Bonds::Coupons::CreateService, type: :service do
  subject(:service_call) { described_class.call(quote: quote, ticker_info: ticker_info) }

  let!(:quote) { create :quote }
  let(:params) {
    {
      start_date:       '2020-08-24',
      buy_back_date:    '2023-08-21',
      end_date:         '2024-08-19',
      coupon_frequency: '4',
      coupon_value:     24.93
    }
  }

  describe '.call' do
    context 'for typical params' do
      let(:ticker_info) { params }

      it 'succeeds' do
        expect(service_call.success?).to eq true
      end

      it 'and creates 16 coupons total' do
        expect { service_call }.to change(quote.coupons, :count).by(16)
      end

      it 'but coupons after buy_back_date are without value', :aggregate_failures do
        service_call
        coupons_with_value = Bonds::Coupon.first(12)
        coupons_without_value = Bonds::Coupon.last(4)

        expect(coupons_with_value.all?(&:coupon_value)).to eq true
        expect(coupons_without_value.any?(&:coupon_value)).to eq false
      end
    end

    context 'when no buy_back_date' do
      let(:ticker_info) { params.merge(buy_back_date: nil) }

      it 'succeeds' do
        expect(service_call.success?).to eq true
      end

      it 'and creates 16 coupons total' do
        expect { service_call }.to change(quote.coupons, :count).by(16)
      end

      it 'and all coupons have value' do
        service_call

        expect(Bonds::Coupon.all.all?(&:coupon_value)).to eq true
      end
    end

    context 'when no coupon_frequency' do
      let(:ticker_info) { params.merge(coupon_frequency: nil) }

      it 'succeeds' do
        expect(service_call.success?).to eq true
      end

      it 'and creates 1 coupon' do
        expect { service_call }.to change(quote.coupons, :count).by(1)
      end

      it 'and coupon have value' do
        service_call

        expect(Bonds::Coupon.all.all?(&:coupon_value)).to eq true
      end
    end

    context 'when no end_date' do
      let(:ticker_info) { params.merge(end_date: nil) }

      it 'succeeds' do
        expect(service_call.success?).to eq true
      end

      it 'and creates 8 coupons total for 2 years' do
        expect { service_call }.to change(quote.coupons, :count).by(8)
      end
    end
  end
end
