# frozen_string_literal: true

describe Users::ConfirmationsController, type: :request do
  describe 'GET#check' do
    it 'renders check confirmation page' do
      get check_confirmations_en_path

      expect(last_response.body).to include('Check your email')
    end
  end
end
