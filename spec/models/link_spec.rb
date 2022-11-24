require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  describe '#url' do
    it { should allow_value('https://gist.github.com/cartotien/09d41dc955dea1157744afdc08b77c03').for(:url) }
    it { should_not allow_value('foobar').for(:url) }
  end

  describe 'gist?' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:gist) { create :link, linkable: question }

    it 'should be true if the address is gist.github.com' do
      expect(gist.gist?).to be true
    end

    it 'should be false if anything besides that' do
      expect(Link.create!(name: 'so', url: 'https://stackoverflow.com/', linkable: question).gist?).to be false
    end
  end
end
