# frozen_string_literal: true

every 1.minute do
  runner 'Uploads::PerformUploadingJob.perform_later'
end

every :day, at: '6am' do
  runner 'Quotes::Collection::SyncronizeJob.perform_later'
end
