# frozen_string_literal: true

module Positions
  module Creation
    class BaseService
      private

      def create_position(args={})
        Users::Position.create(args)
      end
    end
  end
end
