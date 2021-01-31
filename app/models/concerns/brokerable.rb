# frozen_string_literal: true

module Brokerable
  extend ActiveSupport::Concern

  TINKOFF  = 'tinkoff'
  SBERBANK = 'sberbank'
  VTB      = 'vtb'
  OTKRITIE = 'otkritie'
  BKS      = 'bks'
  FINAM    = 'finam'
  ALFABANK = 'alfabank'
  FREEDOM  = 'freedom_finance'

  LISTABLE_BROKERS = [
    { name: { en: 'Tinkoff', ru: 'Тинькофф' }, index: 0, formats: '.xls,.xlsx', available: true },
    { name: { en: 'Sberbank', ru: 'Сбербанк' }, index: 1, formats: '', available: true },
    { name: { en: 'VTB', ru: 'ВТБ' }, index: 2, formats: '', available: false },
    { name: { en: 'Otkritie', ru: 'Открытие' }, index: 3, formats: '', available: false },
    { name: { en: 'BKS', ru: 'БКС' }, index: 4, formats: '', available: false },
    { name: { en: 'Finam', ru: 'Финам' }, index: 5, formats: '', available: false },
    { name: { en: 'Alfabank', ru: 'Альфабанк' }, index: 6, formats: '', available: false },
    { name: { en: 'Freedom Finance', ru: 'Фридом Финанс' }, index: 7, formats: '', available: false }
  ].freeze
end
