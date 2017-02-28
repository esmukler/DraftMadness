FactoryGirl.define do
  factory :league do
    name         'Best League Ever'
    description  'This league is so great!'
    password     'secret_password'
    commissioner { create(:user) }

    after(:create) do |league, evaluator|
      if evaluator.commissioner
        FactoryGirl.create(:owner, user: league.commissioner, league: league)
      end
    end

    trait :full do
      after(:create) do |league|
        until league.full? do
          create(:owner, league: league)
        end
      end
    end
  end
end
