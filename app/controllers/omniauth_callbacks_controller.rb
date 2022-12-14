class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    sign_in_on_callback('Github')
  end

  def vkontakte
    sign_in_on_callback('Vkontakte')
  end

  private

  def sign_in_on_callback(provider)
    @user = User.find_for_oauth(request.env['omniauth.auth'])

    if @user&.persisted?
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, kind: provider) if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end
end
