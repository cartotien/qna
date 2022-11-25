RSpec.shared_examples 'Rateable' do
  it { is_expected.to have_many(:rates).dependent(:destroy) }

  let!(:rateable) { create described_class.to_s.downcase.to_sym }
  let(:user) { create(:user, :confirmed_user) }

  describe '#uprate' do
    let(:rate) { create(:rate, rateable: rateable, user: user, value: 1) }

    it 'should uprate rateable if rate is non-existent' do
      expect { rateable.uprate(user) }.to change(rateable.rates, :count)
    end

    it "shouldn't uprate rateable if rate exists" do
      rate
      expect { rateable.uprate(user) }.not_to change(rateable.rates, :count)
    end
  end

  describe '#downrate' do
    let(:rate) { create(:rate, rateable: rateable, user: user, value: -1) }

    it 'should downrate rateable if rate is non-existent' do
      expect { rateable.downrate(user) }.to change(rateable.rates, :count)
    end

    it "shouldn't downrate rateable if rate exists" do
      rate
      expect { rateable.downrate(user) }.not_to change(rateable.rates, :count)
    end
  end

  describe '#cancel_rate' do
    let!(:rate) { create(:rate, rateable: rateable, user: user, value: -1) }

    it 'should destroy rate of user if exists' do
      expect { rateable.cancel_rate(user) }.to change(rateable.rates, :count)
    end
  end
end
