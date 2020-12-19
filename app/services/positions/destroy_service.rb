# frozen_string_literal: true

module Positions
  class DestroyService
    prepend BasicService

    def call(position_id:, user:)
      user.positions.find_by(id: position_id)&.destroy
    end
  end
end
