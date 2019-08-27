class DatasetItem < ApplicationRecord
    belongs_to :dataset
    has_many :project_dataset_items
end
