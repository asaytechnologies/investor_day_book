# frozen_string_literal: true

module Positions
  module Creation
    class PlanService < BaseService
      prepend BasicService

      def call(args={})
        create_position(args.merge(plan: true))
      end
    end
  end
end
