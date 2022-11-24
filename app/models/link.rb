class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, presence: true
  validates :url, format: { with: /\A#{URI::DEFAULT_PARSER.make_regexp}\z/ }, presence: true

  def gist?
    url.start_with?('https://gist.github.com')
  end
end
