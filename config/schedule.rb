# frozen_string_literal: true

every 1.minute do
  runner 'Uploads::PerformUploadingJob.perform_later'
end
