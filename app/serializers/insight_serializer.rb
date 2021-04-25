# frozen_string_literal: true

class InsightSerializer < BasisSerializer
  extend ViewHelper

  attributes :id, :stats, :plan, :parentable_type, :parentable_id, :insightable_type, :currency

  attribute :insightable_name do |object|
    case object.insightable_type
    when 'Quote' then object.insightable.security.name[I18n.locale.to_s]
    when 'Sector' then object.insightable.name[I18n.locale.to_s]
    when 'ActiveType' then object.insightable.name
    when 'Portfolios::Cash' then object.insightable.amount_currency
    end
  end

  attribute :security_type do |object|
    object.insightable_type == 'Quote' ? object.insightable.security.type : nil
  end

  attribute :security_sector_name do |object|
    object.insightable_type == 'Quote' ? object.insightable.security.sector&.name&.dig(I18n.locale.to_s) : nil
  end

  attribute :security_sector_color do |object|
    object.insightable_type == 'Sector' ? object.insightable.color : nil
  end

  attribute :quote_price do |object|
    case object.insightable_type
    when 'Quote' then money_presenter(object.insightable.price, object.insightable.price_currency)
    end
  end
end
