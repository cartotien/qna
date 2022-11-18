FactoryBot.define do
  factory :answer do
    body
    best { false }
  end

  trait :invalid_answer do
    body { nil }
  end
end
