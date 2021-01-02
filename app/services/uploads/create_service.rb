# frozen_string_literal: true

module Uploads
  class CreateService
    prepend BasicService

    def call(params:)
      Upload.create(params)
    end
  end
end
