# frozen_string_literal: true

module Positions
  class CreateService
    prepend BasicService

    def initialize(
      buy_service:  ::Positions::Creation::BuyService,
      sell_service: ::Positions::Creation::SellService,
      plan_service: ::Positions::Creation::PlanService
    )
      @buy_service  = buy_service
      @sell_service = sell_service
      @plan_service = plan_service
    end

    def call(args={})
      @args = args

      service = position_service.call(position_params)
      if service.success?
        puts service.result.inspect
        refresh_position_insights(service.result)
        @result = service.result
      else
        @errors = service.errors
      end
    end

    private

    def position_service
      case @args[:operation].to_i
      when 0 then @buy_service
      when 1 then @sell_service
      when 2 then @plan_service
      end
    end

    def refresh_position_insights(position)
      Insights::RefreshService.call(parentable: position.portfolio, insightable: position.quote, plan: position.plan)
    end

    def position_params
      @args
        .except(:operation)
        .merge(operation_date: operation_date)
    end

    def operation_date
      return if @args[:operation_date].blank?
      return DateTime.parse(@args[:operation_date]) if @args[:operation_date].is_a?(String)

      @args[:operation_date]
    rescue Date::Error => _e
      nil
    end
  end
end
