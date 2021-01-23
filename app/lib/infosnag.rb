# frozen_string_literal: true

class Infosnag
  NOTIFICATIONS_CHAT_ID = Rails.application.credentials.dig(:telegram, :notify_chat_id)

  def self.call(*args)
    new.call(*args)
  end

  def initialize(info_service: TelegramApi::Client.new)
    @info_service = info_service
  end

  def call(text:)
    @info_service.send_message(chat_id: NOTIFICATIONS_CHAT_ID, text: text)
  end
end
