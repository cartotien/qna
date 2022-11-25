class User < ApplicationRecord
  has_many :awards
  has_many :questions
  has_many :answers
  has_many :rates

  validates :nickname, presence: true, uniqueness: true

  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author_of?(resource)
    id == resource.user_id
  end
end
