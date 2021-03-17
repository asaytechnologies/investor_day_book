# frozen_string_literal: true

module Users
  class PositionSerializer < BasisSerializer
    extend ViewHelper

    attributes :id, :selling_position, :amount, :price

    attribute :operation_date, if: Proc.new { |_, params| params_with_field?(params, 'operation_date')} do |object|
      object.operation_date&.strftime('%d.%m.%Y')
    end

    attribute :quote_currency, if: Proc.new { |_, params| params_with_field?(params, 'quote_currency') } do |object|
      object.quote.price_currency
    end

    attribute :security_name, if: Proc.new { |_, params| params_with_field?(params, 'security_name') } do |object|
      object.quote.security.name[I18n.locale.to_s]
    end

    attribute :security_ticker, if: Proc.new { |_, params| params_with_field?(params, 'security_ticker') } do |object|
      object.quote.security.ticker
    end
  end
end
