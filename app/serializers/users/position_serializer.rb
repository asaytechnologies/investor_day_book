# frozen_string_literal: true

module Users
  class PositionSerializer
    include JSONAPI::Serializer

    attributes :id
  end
end
