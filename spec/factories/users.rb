FactoryBot.define do
  sequence :email do |n|
    "test#{n}@email.com"
  end

  sequence :nickname do |n|
    "test#{n}"
  end
  factory :user do
    first_name { "MyString" }
    last_name { "MyString" }
    nickname
    email
    password { 'MyPassword' }
    password_confirmation { 'MyPassword' }
  end

  trait :confirmed_user do
    confirmed_at { Time.now }
  end
end
