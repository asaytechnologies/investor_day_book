# frozen_string_literal: true

class QuoteSerializer
  include JSONAPI::Serializer
  extend ViewHelper

  attributes :id, :price_currency

  attribute :security_type do |object|
    object.security.type
  end

  attribute :security_name do |object|
    object.security.name[I18n.locale.to_s]
  end

  attribute :security_ticker do |object|
    object.security.ticker
  end

  attribute :price do |object|
    money_presenter(object.price, object.price_currency)
  end
end
