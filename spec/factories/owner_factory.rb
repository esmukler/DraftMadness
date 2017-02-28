FactoryGirl.define do
  factory :owner do
    sequence(:team_name) { |n| "Bracket Busters No. #{n}" }
    motto                'We the best'
    user                 { create(:user) }
    league               { create(:league) }
  end
end
