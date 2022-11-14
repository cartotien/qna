module RequestHelper
  def sign_in(user)
    post user_session_path, params: {
      user: {
        email: user.email, password: user.password
      }
    }
    follow_redirect!
  end
end
