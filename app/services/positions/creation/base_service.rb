# frozen_string_literal: true

module Positions
  module Creation
    class BaseService
      private

      def create_position(args={})
        position = Users::Position.new(args)
        if position.save
          @result = position
        else
          @errors = position.errors.full_messages
        end
      end
    end
  end
end
