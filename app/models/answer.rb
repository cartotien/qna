class Answer < ApplicationRecord
  include Rateable
  include Commentable

  belongs_to :user
  belongs_to :question

  has_many :links, as: :linkable, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc) }

  def mark_as_best
    return if best == true

    transaction do
      self.class.where(question_id: question_id).update_all(best: false)
      update(best: true)
      question.award&.update!(user: user)
    end
  end
end
