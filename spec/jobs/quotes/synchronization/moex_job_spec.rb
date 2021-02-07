# frozen_string_literal: true

describe Quotes::Synchronization::MoexJob, type: :service do
  subject(:job_call) { described_class.perform_now }

  before do
    allow(Quotes::Collection::SynchronizeService).to receive(:call)
    allow(Infosnag).to receive(:call)
  end

  after do
    Timecop.return
  end

  context 'for valid day' do
    before do
      Timecop.freeze(DateTime.parse('2021-02-06T12:00'))
    end

    it 'calls sync service' do
      job_call

      expect(Quotes::Collection::SynchronizeService).to have_received(:call).with(source: 'moex', date: '2021-02-05')
    end

    it 'and calls info service' do
      job_call

      expect(Infosnag).to have_received(:call)
    end
  end

  context 'for invalid day' do
    before do
      Timecop.freeze(DateTime.parse('2021-02-07T12:00'))
    end

    it 'does not call sync service' do
      job_call

      expect(Quotes::Collection::SynchronizeService).not_to have_received(:call)
    end

    it 'and does not call info service' do
      job_call

      expect(Infosnag).not_to have_received(:call)
    end
  end
end
