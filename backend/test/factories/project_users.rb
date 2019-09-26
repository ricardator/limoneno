# frozen_string_literal: true

FactoryBot.define do
  factory :project_user do
    initialize_with do
      new(
        project_id: create(:project).id,
        user_id: create(:user).id
      )
    end
  end
end
