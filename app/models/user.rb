# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :rememberable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :validatable

  has_many :portfolios, inverse_of: :user, dependent: :destroy
  has_many :positions, class_name: 'Users::Position', through: :portfolios

  has_many :uploads, dependent: :destroy

  scope :unconfirmed, -> { where confirmed_at: nil }

  after_create :send_create_notification

  private

  def send_create_notification
    Users::CreateNotificationJob.perform_later(id: id)
  end
end
