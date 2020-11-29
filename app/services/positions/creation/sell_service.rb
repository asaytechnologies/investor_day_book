# frozen_string_literal: true

module Positions
  module Creation
    class SellService < BaseService
      prepend BasicService

      def call(args={})
        create_position(args.merge(selling_position: true))
        decrease_securities_in_portfolio(args[:portfolio], args[:quote], args[:amount])
      end

      private

      def decrease_securities_in_portfolio(portfolio, quote, amount)
        positions_with_existed_securities(portfolio, quote).find_each do |position|
          break if amount.zero?

          securities_for_selling = position.amount - position.sold_amount
          if securities_for_selling <= amount
            position.update(sold_all: true, sold_amount: position.amount)
            amount -= securities_for_selling
          else
            position.update(sold_amount: position.sold_amount + amount)
            amount = 0
          end
        end
      end

      def positions_with_existed_securities(portfolio, quote)
        portfolio
          .positions
          .where(quote: quote)
          .buying
          .with_unsold_securities
          .order(created_at: :asc)
      end
    end
  end
end
