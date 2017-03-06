FactoryGirl.define do
  factory :school do
    name 'UCLA'
    mascot 'Bruins'
    seed { Seed.create(seed_number: rand(1..8), region: 'West') }
    year Time.now.year

    trait :old do
      after(:create) do |school|
        school.update(year: Time.now.year - 1)
      end
    end
  end
end
