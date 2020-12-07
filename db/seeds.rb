# frozen_string_literal: true

Quotes::Collection::SyncronizeService.call(source: 'moex', date: '2020-12-04')
Quotes::Collection::SyncronizeService.call(source: 'tinkoff')

_technology    = Sector.create(name: { en: 'Technology', ru: 'Информационные технологии' })
_financial     = Sector.create(name: { en: 'Financial', ru: 'Финансовый сектор' })
_communication = Sector.create(name: { en: 'Communication services', ru: 'Коммуникационные услуги' })
_healthcare    = Sector.create(name: { en: 'Healthcare', ru: 'Здравоохранение' })
_cyclical      = Sector.create(name: { en: 'Consumer cyclical', ru: 'Товары второй необходимости' })
_industrials   = Sector.create(name: { en: 'Industrials', ru: 'Промышленность' })
_energy        = Sector.create(name: { en: 'Energy', ru: 'Нефтегазовый сектор' })
_defensive     = Sector.create(name: { en: 'Consumer defensive', ru: 'Товары первой необходимости' })
_real_estate   = Sector.create(name: { en: 'Real estate', ru: 'Недвижимость' })
_utilities     = Sector.create(name: { en: 'Utilities', ru: 'Энергетика' })
_materials     = Sector.create(name: { en: 'Basic materials', ru: 'Сырьевой сектор' })

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
