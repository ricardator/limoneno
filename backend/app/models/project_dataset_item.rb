class ProjectDatasetItem < ApplicationRecord
    belongs_to :project
    belongs_to :user
    belongs_to :dataset
    belongs_to :dataset_item
end
