# frozen_string_literal: true

module Users
  class CreateNotificationService
    prepend BasicService

    def call(id:)
      Infosnag.call(text: info_text(User.find(id)))
    end

    private

    def info_text(user)
      [
        "Зарегистрирован пользователь - #{user.email}",
        "Всего зарегистрировано пользователей - #{User.count}",
        "Не подтвержденные пользователи - #{User.unconfirmed.count}"
      ].join("\n")
    end
  end
end
