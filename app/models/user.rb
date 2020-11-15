# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :rememberable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :validatable

  has_many :accounts, class_name: 'Users::Account', inverse_of: :user, dependent: :destroy
end
