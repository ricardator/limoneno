FactoryBot.define do
  factory :dataset do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
  end
end