class Project < ApplicationRecord
    has_many :project_datasets
    has_many :project_users
    has_many :project_dataset_items
    has_many :users, through: :project_users
    has_many :datasets, through: :project_datasets
end
