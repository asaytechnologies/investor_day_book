# frozen_string_literal: true

describe Users::CreateNotificationJob, type: :service do
  subject(:job_call) { described_class.perform_now(id: user.id) }

  let(:user) { create :user }

  before do
    allow(Users::CreateNotificationService).to receive(:call)
  end

  it 'calls notification service' do
    job_call

    expect(Users::CreateNotificationService).to have_received(:call)
  end
end
