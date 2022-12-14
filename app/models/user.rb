class User < ApplicationRecord
  has_many :awards
  has_many :questions
  has_many :answers
  has_many :rates
  has_many :identities, dependent: :destroy

  validates :nickname, presence: true, uniqueness: true

  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable, omniauth_providers: %i[github vkontakte]

  def author_of?(resource)
    id == resource.user_id
  end

  def self.find_for_oauth(auth)
    OmniauthAuthenticationService.new(auth).call
  end
end
