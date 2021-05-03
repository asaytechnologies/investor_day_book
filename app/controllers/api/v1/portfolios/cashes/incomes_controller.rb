# frozen_string_literal: true

module Api
  module V1
    module Portfolios
      module Cashes
        class IncomesController < Api::V1::BaseController
          before_action :find_cashable, only: %i[index]

          def index
            render json: {
              amount:   perform_analytics,
              currency: 'RUB'
            }, status: :ok
          end

          private

          def find_cashable
            cashable =
              params[:portfolio_id] ? Current.user.portfolios.find_by(id: params[:portfolio_id]) : Current.user
            @cashes = ::Portfolios::Cash.income.where(cashable: cashable)
          end

          def perform_analytics
            @cashes.inject(0) { |acc, cash|
              acc + cash.amount_cents * exchange_rates[cash.amount_currency.to_sym] / 100
            }.to_f
          end

          def exchange_rates
            @exchange_rates ||=
              Rails.cache.fetch('RUB_exchange_rates', expires_in: 4.hours) do
                rub_exchange_rates = ExchangeRate.where(rate_currency: 'RUB')
                {
                  RUB: rub_exchange_rates.find { |e| e.base_currency == 'RUB' }.rate_amount,
                  USD: rub_exchange_rates.find { |e| e.base_currency == 'USD' }.rate_amount,
                  EUR: rub_exchange_rates.find { |e| e.base_currency == 'EUR' }.rate_amount
                }
              end
          end
        end
      end
    end
  end
end
