class ProjectDataset < ApplicationRecord
    belongs_to :project
    belongs_to :dataset
end
