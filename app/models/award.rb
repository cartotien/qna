class Award < ApplicationRecord
  belongs_to :question
  belongs_to :user, optional: true

  validates :name, :link, presence: true
end
