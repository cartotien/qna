class User < ApplicationRecord
  has_many :questions
  has_many :answers
  validates :nickname, presence: true, uniqueness: true

  devise :confirmable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author_of_answer?(answer)
    answers.include?(answer)
  end
end
