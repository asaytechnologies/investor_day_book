# frozen_string_literal: true

module Portfolios
  module Index
    class ListElementComponent < ViewComponent::Base
      def initialize(portfolio:)
        @portfolio = portfolio
        @cashes    = @portfolio.cashes.where.not(amount_cents: 0)
      end

      private

      def incomes
        @incomes ||= @cashes.income.map { |cash| present_cash(cash) }.join(', ')
      end

      def balance
        @balance ||= @cashes.balance.map { |cash| present_cash(cash) }.join(', ')
      end

      def present_cash(cash)
        "#{Money::Currency.new(cash.amount_currency).symbol} #{Money.new(cash.amount_cents)}"
      end
    end
  end
end
