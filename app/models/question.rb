class Question < ApplicationRecord
  include Rateable
  include Commentable

  belongs_to :user

  has_one :award, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :links, as: :linkable, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :award, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
end
