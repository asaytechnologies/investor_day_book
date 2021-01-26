# frozen_string_literal: true

module ViewHelper
  def money_presenter(price, currency)
    "#{price} #{Money::Currency.new(currency).symbol}"
  end
end
