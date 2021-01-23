# frozen_string_literal: true

module ViewHelper
  def money_presenter(price, currency)
    "#{Money::Currency.new(currency).symbol} #{price}"
  end
end
