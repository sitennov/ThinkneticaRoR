module OmniauthMacros
  def mock_auth_hash(provider, email = '123@mail.ru')
    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new(
      provider: provider.to_s,
      uid: '123456',
      info: {
        name: 'mockuser',
        email: email
      },
      credentials: {
        token: 'mock_token',
        secret: 'mock_secret'
      }
    )
  end
end
