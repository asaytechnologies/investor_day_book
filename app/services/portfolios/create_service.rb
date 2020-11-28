# frozen_string_literal: true

module Portfolios
  class CreateService
    prepend BasicService

    def call(args={})
      Portfolio.create(args)
    end
  end
end
