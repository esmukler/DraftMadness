FactoryGirl.define do
  factory :school do
    name   'UCLA'
    mascot 'Bruins'
    seed   { Seed.create(seed_number: rand(1..8), region: 'West') }
    year   Time.now.year
    slug { name.parameterize }

    trait :old do
      after(:create) do |school|
        school.update(year: Time.now.year - 1)
      end
    end

    trait :florida do
      name   'Florida'
      mascot 'Gators'
    end
  end
end
