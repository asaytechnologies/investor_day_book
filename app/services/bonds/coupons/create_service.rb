# frozen_string_literal: true

module Bonds
  module Coupons
    class CreateService
      prepend BasicService

      DAYS_FREQUENCY = {
        '12' => 30,
        '4'  => 91,
        '2'  => 182,
        '1'  => 364
      }.freeze

      def call(quote:, ticker_info: {})
        @quote            = quote
        @start_date       = parse_time(ticker_info[:start_date])
        @buy_back_date    = parse_time(ticker_info[:buy_back_date])
        @end_date         = parse_time(ticker_info[:end_date]) || (@start_date + 2.years)
        @coupon_frequency = DAYS_FREQUENCY[ticker_info[:coupon_frequency]]
        @coupon_value     = ticker_info[:coupon_value].to_f

        perform_creation
      end

      private

      def parse_time(value)
        return unless value

        DateTime.parse(value)
      end

      def perform_creation
        return create_coupon if @coupon_frequency.nil?

        create_coupons
      end

      def create_coupons
        payment_date = @start_date + @coupon_frequency.days
        while payment_date <= @end_date
          create_coupon(payment_date: payment_date, coupon_value: coupon_value(payment_date))
          payment_date += @coupon_frequency.days
        end
      end

      def coupon_value(payment_date)
        return @coupon_value if @buy_back_date.nil?

        payment_date <= @buy_back_date ? @coupon_value : nil
      end

      def create_coupon(payment_date: @end_date, coupon_value: @coupon_value)
        @quote.coupons.create(payment_date: payment_date, coupon_value: coupon_value)
      end
    end
  end
end
