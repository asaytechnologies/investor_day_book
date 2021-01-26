# frozen_string_literal: true

set :chronic_options, hours24: true

every 1.minute do
  runner 'Uploads::PerformUploadingJob.perform_later'
end

# synchronize quotes with MOEX Exchange
every :day, at: '3:00' do
  runner 'Quotes::Synchronization::MoexJob.perform_later'
end

# synchronize quotes with Tinkoff broker
every :day, at: ['5:00', '17:00'] do
  runner 'Quotes::Synchronization::TinkoffJob.perform_later'
end

# synchronize exchange rates
every :day, at: ['7:00', '11:00', '15:00'] do
  runner 'Quotes::Synchronization::ExchangeRatesJob.perform_later'
end
