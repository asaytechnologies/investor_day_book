# frozen_string_literal: true

require 'csv'

Quotes::Collection::SyncronizeService.call(source: 'moex', date: '2021-01-08')
Quotes::Collection::SyncronizeService.call(source: 'tinkoff')
ExchangeRates::SyncronizeService.call

technology    = Sector.create(name: { en: 'Technology', ru: 'Информационные технологии' }, color: '#2480cc')
financial     = Sector.create(name: { en: 'Financial', ru: 'Финансовый сектор' }, color: '#f93b4b')
communication = Sector.create(name: { en: 'Communication services', ru: 'Коммуникационные услуги' }, color: '#ff7518')
healthcare    = Sector.create(name: { en: 'Healthcare', ru: 'Здравоохранение' }, color: '#00c1ec')
cyclical      = Sector.create(name: { en: 'Consumer cyclical', ru: 'Товары второй необходимости' }, color: '#f4b400')
industrials   = Sector.create(name: { en: 'Industrials', ru: 'Промышленность' }, color: '#7747ff')
energy        = Sector.create(name: { en: 'Energy', ru: 'Нефтегазовый сектор' }, color: '#fe5da3')
defensive     = Sector.create(name: { en: 'Consumer defensive', ru: 'Товары первой необходимости' }, color: '#eba23a')
real_estate   = Sector.create(name: { en: 'Real estate', ru: 'Недвижимость' }, color: '#00796b')
utilities     = Sector.create(name: { en: 'Utilities', ru: 'Энергетика' }, color: '#29b327')
materials     = Sector.create(name: { en: 'Basic materials', ru: 'Сырьевой сектор' }, color: '#f06292')

# update sectors for securities
sectors = Sector.all.each_with_object({}) do |sector, acc|
  acc[sector.name['en'].downcase] = sector.id
end

client = YahooFinanceApi::Client.new
Share.where(sector: nil).each_slice(100) do |group|
  group.each do |share|
    response = client.asset_profile(ticker: share.ticker)
    next if response.dig('quoteSummary', 'result').nil?

    response.dig('quoteSummary', 'result').each do |result|
      sector = result.dig('assetProfile', 'sector')
      sector = 'Financial' if sector == 'Financial Services'
      sector = sector&.downcase
      next if sector.nil?

      real_sector_id = sectors[sector]
      next if real_sector_id.nil?

      share.update(sector_id: real_sector_id)
    end
  end
  sleep(15)
end

# update sectors for russian shares
Share.find_by(ticker: 'GMKN').update(sector: materials) # Норильский никель
Share.find_by(ticker: 'CHMF').update(sector: materials) # Северсталь
Share.find_by(ticker: 'PLZL').update(sector: materials) # Полюс
Share.find_by(ticker: 'ALRS').update(sector: materials) # Алроса
Share.find_by(ticker: 'RUAL').update(sector: materials) # Русал
Share.find_by(ticker: 'PHOR').update(sector: materials) # Фосагро
Share.find_by(ticker: 'POLY').update(sector: materials) # Полиметал

Share.find_by(ticker: 'GAZP').update(sector: energy) # Газпром
Share.find_by(ticker: 'NVTK').update(sector: energy) # Новатэк
Share.find_by(ticker: 'LKOH').update(sector: energy) # Лукойл
Share.find_by(ticker: 'ROSN').update(sector: energy) # Роснефть
Share.find_by(ticker: 'SIBN').update(sector: energy) # Газпром нефть
Share.find_by(ticker: 'SNGS').update(sector: energy) # Сургутнефтегаз

Share.find_by(ticker: 'AFLT').update(sector: industrials) # Аэрофлот
Share.find_by(ticker: 'TRMK').update(sector: industrials) # ТМК
Share.find_by(ticker: 'CHEP').update(sector: industrials) # ЧТПЗ
Share.find_by(ticker: 'TRCN').update(sector: industrials) # Трансконтейнер
Share.find_by(ticker: 'NMTP').update(sector: industrials) # НМТП
Share.find_by(ticker: 'MSTT').update(sector: industrials) # Мостотрест
Share.find_by(ticker: 'KMAZ').update(sector: industrials) # Камаз

Share.find_by(ticker: 'RSTIP').update(sector: utilities) # Россети
Share.find_by(ticker: 'HYDR').update(sector: utilities) # Русгидро
Share.find_by(ticker: 'IRAO').update(sector: utilities) # Интер РАО
Share.find_by(ticker: 'LSNG').update(sector: utilities) # Ленэнерго
Share.find_by(ticker: 'UPRO').update(sector: utilities) # Юнипро

Share.find_by(ticker: 'MGNT').update(sector: defensive) # Магнит
Share.find_by(ticker: 'FIVE').update(sector: defensive) # X5 Retail Group
Share.find_by(ticker: 'DSKY').update(sector: defensive) # Детский мир
Share.find_by(ticker: 'APTK').update(sector: defensive) # Аптечная сеть 36,6
Share.find_by(ticker: 'GCHE').update(sector: defensive) # Черкизово

Share.find_by(ticker: 'MVID').update(sector: cyclical) # М-видео
Share.find_by(ticker: 'SVAV').update(sector: cyclical) # Соллерс
Share.find_by(ticker: 'OBUV').update(sector: cyclical) # Обувь России

Share.find_by(ticker: 'LSRG').update(sector: real_estate) # ЛСР
Share.find_by(ticker: 'PIKK').update(sector: real_estate) # ПИК
Share.find_by(ticker: 'ETLN').update(sector: real_estate) # Etalon Group PLC

Share.find_by(ticker: 'YNDX').update(sector: communication) # Яндекс
Share.find_by(ticker: 'MTSS').update(sector: communication) # МТС
Share.find_by(ticker: 'RTKM').update(sector: communication) # Ростелеком
Share.find_by(ticker: 'MGTSP').update(sector: communication) # МГТС
Share.find_by(ticker: 'VEON').update(sector: communication) # Veon
Share.find_by(ticker: 'MAIL').update(sector: communication) # Mail.ru

Share.find_by(ticker: 'SBER').update(sector: financial) # Сбербанк
Share.find_by(ticker: 'VTBR').update(sector: financial) # ВТБ
Share.find_by(ticker: 'TCSG').update(sector: financial) # TCS Group
Share.find_by(ticker: 'MOEX').update(sector: financial) # Мосбиржа
Share.find_by(ticker: 'BSPB').update(sector: financial) # Банк Санкт-Петербург

Share.find_by(ticker: 'PRTK').update(sector: healthcare) # Протек
Share.find_by(ticker: 'LIFE').update(sector: healthcare) # Фармсинтез

Share.find_by(ticker: 'QIWI').update(sector: technology) # Киви

sector_links = {
  'technology'    => technology,
  'financial'     => financial,
  'communication' => communication,
  'healthcare'    => healthcare,
  'cyclical'      => cyclical,
  'industrials'   => industrials,
  'energy'        => energy,
  'defensive'     => defensive,
  'real_estate'   => real_estate,
  'utilities'     => utilities,
  'materials'     => materials
}

rows = CSV.read(Rails.root.join('db/stocks.csv'), col_sep: ',', headers: false)
rows.each do |row|
  ticker = row[0]
  sector = sector_links[row[1]]

  Share.find_by(ticker: ticker)&.update(sector: sector)
end
