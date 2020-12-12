# frozen_string_literal: true

module ViewHelper
  def money_presenter(cents, currency)
    "#{Money::Currency.new(currency).symbol} #{Money.new(cents).round}"
  end
end
