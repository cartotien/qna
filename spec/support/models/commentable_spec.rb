RSpec.shared_examples 'Commentable' do
  it { is_expected.to have_many(:comments).dependent(:destroy) }
end
