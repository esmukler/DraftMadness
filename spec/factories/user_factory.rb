FactoryGirl.define do
  factory :user do
    sequence(:email) { |n| "user_#{n}@example.com" }
    password 'secret_password'

    trait :admin do
      is_admin true
    end
  end
end
