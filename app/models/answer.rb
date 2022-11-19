class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  has_many_attached :files

  validates :body, presence: true

  scope :sort_by_best, -> { order(best: :desc) }

  def mark_as_best
    return if best == true

    transaction do
      self.class.where(question_id: question_id).update_all(best: false)
      update(best: true)
    end
  end
end
