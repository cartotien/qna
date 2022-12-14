module OmniauthHelper
  def mock_auth(provider, email)
    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new({
                                                                          provider: provider.to_s,
                                                                          uid: '1235',
                                                                          info: { email: email.to_s,
                                                                                  nickname: 'testname' }
                                                                        })
  end
end
