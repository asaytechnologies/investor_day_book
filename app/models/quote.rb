# frozen_string_literal: true

class Quote < ApplicationRecord
  include Sourceable

  ThinkingSphinx::Callbacks.append(self, behaviours: [:real_time])

  belongs_to :security

  has_many :positions,
           class_name: 'Users::Position',
           inverse_of: :quote,
           dependent:  :destroy

  has_many :coupons, class_name: 'Bonds::Coupon', inverse_of: :quote, dependent: :destroy
  has_many :insights, as: :insightable, dependent: :destroy

  def coupons_sum_for_time_range(time_range=1.year)
    beginning_of_day = DateTime.now.beginning_of_day
    Rails.cache.fetch("quotes/#{id}/coupons_sum/#{beginning_of_day}") do
      coupons
        .where('payment_date > ? AND payment_date < ?', beginning_of_day, beginning_of_day + time_range)
        .pluck(:coupon_value)
        .sum
    end
  end
end
