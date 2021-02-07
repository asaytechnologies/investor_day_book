# frozen_string_literal: true

describe Uploads::PerformUploadingJob, type: :service do
  subject(:job_call) { described_class.perform_now }

  before do
    allow(Uploads::PerformUploadingService).to receive(:call)
  end

  it 'calls uploading service' do
    job_call

    expect(Uploads::PerformUploadingService).to have_received(:call)
  end
end
