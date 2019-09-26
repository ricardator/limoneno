# frozen_string_literal: true

FactoryBot.define do
  factory :project do
    name { Faker::Lorem.sentence }
    description { Faker::Lorem.sentence }
    clasification_type { 3 }
    entities { '[{"name":"entity"}]' }
    clasifications { '[{"name":"clasification"}]' }
    status { 1 }
  end
end
