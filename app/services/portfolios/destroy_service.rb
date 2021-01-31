# frozen_string_literal: true

module Portfolios
  class DestroyService
    prepend BasicService

    def call(user:, id:)
      portfolio = user.portfolios.find_by(id: id)
      return unless portfolio

      portfolio.destroy
    end
  end
end
