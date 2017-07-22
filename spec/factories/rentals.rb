FactoryGirl.define do
  factory :rental do
    name { Faker::Lorem.word } 
    daily_rate {120}
  end
end
