# frozen_string_literal: true

every 1.minute do
  runner 'Uploads::PerformUploadingJob.perform_later'
end

# synchronize quotes with MOEX Exchange
every :day, at: '6:00' do
  runner 'Quotes::Synchronization::MoexJob.perform_later'
end

# synchronize quotes with Tinkoff broker
every :day, at: ['8:00', '20:00'] do
  runner 'Quotes::Synchronization::TinkoffJob.perform_later'
end

# synchronize exchange rates
every :day, at: ['10:00', '14:00', '18:00'] do
  runner 'Quotes::Synchronization::ExchangeRatesJob.perform_later'
end
