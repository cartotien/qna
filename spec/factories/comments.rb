FactoryBot.define do
  factory :comment do
    association :user, factory: :user

    content { 'Comment' }
  end
end
