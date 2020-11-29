# frozen_string_literal: true

module Positions
  module Creation
    class BuyService < BaseService
      prepend BasicService

      def call(args={})
        create_position(args)
      end
    end
  end
end
