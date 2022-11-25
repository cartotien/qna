FactoryBot.define do
  factory :rate do
    association :user, factory: :user
    association :rateable, factory: :question 

    trait :positive do
      value { 1 }
    end
  end
end
