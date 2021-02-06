# frozen_string_literal: true

describe UploadsController, type: :controller do
  describe '#create' do
    it_behaves_like 'User Auth'
    it_behaves_like 'Unconfirmed User Auth'

    context 'for logged user' do
      sign_in_user

      before { allow(Uploads::CreateService).to receive(:call) }

      it 'calls uploads create service' do
        post :create, params: { upload: { name: 'portfolio_initial_data', guid: '01234' } }

        expect(Uploads::CreateService).to have_received(:call)
      end
    end

    def do_request
      post :create, params: { upload: { name: 'portfolio_initial_data', guid: '01234' } }
    end
  end
end
