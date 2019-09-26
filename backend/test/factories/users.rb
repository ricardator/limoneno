# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email(name: name) }
    admin { true }
    password { 'UPPERCASElower&123' }
    password_confirmation { 'UPPERCASElower&123' }
  end
end