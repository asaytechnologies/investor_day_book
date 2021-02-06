# frozen_string_literal: true

module OmniauthMacros
  def google_hash
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      'provider' => 'google_oauth2',
      'uid'      => '123545',
      'info'     => {
        'email' => 'example_google@xyze.it'
      },
      'extra'    => {
        'raw_info' => {}
      }
    )
  end

  def google_invalid_hash
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new(
      'provider' => 'google_oauth2',
      'uid'      => '123545',
      'info'     => {},
      'extra'    => {
        'raw_info' => {}
      }
    )
  end
end
