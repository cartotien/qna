FactoryBot.define do
  sequence :title do |n|
    "MyTitle#{n}"
  end

  sequence :body do |n|
    "MyBody#{n}"
  end

  factory :question do
    title
    body
  end

  trait :invalid do
    title { nil }
  end

  trait :with_file do
    files do
      fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'rails_helper/rb')
    end
  end
end
