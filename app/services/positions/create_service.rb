# frozen_string_literal: true

module Positions
  class CreateService
    prepend BasicService

    def initialize(
      buy_service:  Creation::BuyService,
      sell_service: Creation::SellService,
      plan_service: Creation::PlanService
    )
      @buy_service  = buy_service
      @sell_service = sell_service
      @plan_service = plan_service
    end

    def call(args={})
      case args[:operation]
      when '0' then @buy_service.call(args.except(:operation))
      when '1' then @sell_service.call(args.except(:operation))
      when '2' then @plan_service.call(args.except(:operation))
      end
    end
  end
end
