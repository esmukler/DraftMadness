FactoryGirl.define do
  factory :game do
    school1 { create(:school) }
    school2 { create(:school, :florida) }
    round   0
    start_time { 1.day.from_now }
  end
end
