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
      @args = args

      @result = position_service.call(position_params).result
    end

    private

    def position_service
      case @args[:operation].to_i
      when 0 then @buy_service
      when 1 then @sell_service
      when 2 then @plan_service
      end
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
