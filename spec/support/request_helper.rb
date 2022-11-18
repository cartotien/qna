module RequestHelper
  def sign_in(user)
    post user_session_path, params: {
      user: {
        email: user.email, password: user.password
      }
    }
    follow_redirect!
  end

  def blob
    ActiveStorage::Blob.create_and_upload!(
      io: File.open(Rails.root.join('spec', 'rails_helper.rb')),
      filename: 'rails_helper.rb',
      content_type: 'application/x-ruby'
    )
  end
end
