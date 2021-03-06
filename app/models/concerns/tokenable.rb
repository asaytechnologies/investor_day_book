# frozen_string_literal: true

module Tokenable
  extend ActiveSupport::Concern

  def access_token
    return generate_token if token.blank?
    return generate_token if token_expired?(token)

    token
  end

  private

  def generate_token
    token = JwtService.new.json_response(user: self)[:access_token]
    update(token: token)
    token
  end

  def token_expired?(token)
    JwtService.new.decode(access_token: token).nil?
  end
end
