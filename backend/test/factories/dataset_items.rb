# frozen_string_literal: true

FactoryBot.define do
  factory :dataset_item do
    name { Faker::Lorem.sentence }
    mime { 'none' }
    text { Faker::Lorem.sentence }
    url { 'http://' }
    status { 1 }

    initialize_with do
      new(
        dataset_id: create(:dataset).id
      )
    end
  end
end
