# frozen_string_literal: true

FactoryBot.define do
  factory :project_dataset do
    initialize_with do
      item = create(:dataset_item)
      new(
        dataset_id: item.dataset_id,
        project_id: create(:project).id
      )
    end
  end
end
