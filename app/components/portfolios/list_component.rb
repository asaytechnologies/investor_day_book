# frozen_string_literal: true

module Portfolios
  class ListComponent < ViewComponent::Base
    def initialize(current_user:)
      @current_user = current_user

      present_portfolios
    end

    private

    def present_portfolios
      @portfolios =
        @current_user
        .portfolios
        .includes(:cashes)
        .map { |portfolio| present_portfolio(portfolio) }
    end

    def present_portfolio(portfolio)
      {
        id:      portfolio.id,
        name:    portfolio.name,
        created: portfolio.created_at.strftime('%d.%m.%Y'),
        incomes: incomes(portfolio),
        balance: balance(portfolio)
      }
    end

    def incomes(portfolio)
      portfolio.cashes.filter_map { |cash| present_cash(cash) if !cash.balance? && cash.amount.positive? }.join(', ')
    end

    def balance(portfolio)
      portfolio.cashes.filter_map { |cash| present_cash(cash) if cash.balance? && cash.amount.positive? }.join(', ')
    end

    def present_cash(cash)
      "#{Money::Currency.new(cash.amount_currency).symbol} #{Money.new(cash.amount_cents)}"
    end
  end
end
