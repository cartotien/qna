class OmniauthAuthenticationService
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    identity = Identity.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return identity.user if identity.present?

    user = find_user_by_email || create_new_user

    user.identities.create!(provider: auth.provider, uid: auth.uid.to_s)
    user
  end

  private

  def find_user_by_email
    User.find_by(email: auth.info[:email])
  end

  def create_new_user
    email = auth.info[:email]
    password = Devise.friendly_token[0, 20]
    nickname = auth.info[:nickname].blank? ? email.split('@')[0] : auth.info[:nickname]
    User.create!(nickname: nickname,
                 email: email,
                 password: password,
                 password_confirmation: password)
  end
end
