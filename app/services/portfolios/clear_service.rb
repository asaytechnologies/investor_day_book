# frozen_string_literal: true

module Portfolios
  class ClearService
    prepend BasicService

    def call(user:, id:)
      portfolio = user.portfolios.find_by(id: id)
      return unless portfolio

      portfolio.positions.destroy_all
    end
  end
end
