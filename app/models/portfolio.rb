# frozen_string_literal: true

class Portfolio < ApplicationRecord
  belongs_to :user

  has_many :positions, class_name: 'Users::Position', inverse_of: :portfolio, dependent: :destroy
  has_many :cashes, class_name: 'Portfolios::Cash', inverse_of: :portfolio, dependent: :destroy

  enum source: {
    Brokerable::TINKOFF  => 0,
    Brokerable::SBERBANK => 1,
    Brokerable::VTB      => 2,
    Brokerable::OTKRITIE => 3,
    Brokerable::BKS      => 4,
    Brokerable::FINAM    => 5,
    Brokerable::ALFABANK => 6,
    Brokerable::FREEDOM  => 7
  }

  enum currency: {
    Cashable::USD_UPCASE => 0,
    Cashable::EUR_UPCASE => 1,
    Cashable::RUB_UPCASE => 2
  }

  def broker_name
    presenter = Brokerable::LISTABLE_BROKERS.find { |e| e[:index] == Portfolio.sources[source] }
    return unless presenter

    presenter[:name][I18n.locale]
  end
end
