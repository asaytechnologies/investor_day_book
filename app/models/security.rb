# frozen_string_literal: true

class Security < ApplicationRecord
  belongs_to :industry, optional: true

  has_many :quotes, inverse_of: :security, dependent: :destroy
  has_many :positions,
           class_name: 'Users::Position',
           inverse_of: :security,
           dependent:  :destroy

  def name_en
    name['en']
  end

  def name_ru
    name['ru']
  end
end
