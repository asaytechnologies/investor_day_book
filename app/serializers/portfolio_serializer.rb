# frozen_string_literal: true

class PortfolioSerializer < BasisSerializer
  attributes :id, :name, :currency, :broker_name

  attribute :created_at do |object|
    object.created_at.strftime('%d.%m.%Y')
  end
end
