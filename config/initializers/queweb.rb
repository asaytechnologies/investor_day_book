# frozen_string_literal: true

Que::Web.use(Rack::Auth::Basic) do |user, password|
  [user, password] == [
    Rails.application.credentials.dig(:que, :username),
    Rails.application.credentials.dig(:que, :passowrd)
  ]
end
