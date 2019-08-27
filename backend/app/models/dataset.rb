class Dataset < ApplicationRecord
    include ActiveModel::Serializers::JSON
    has_many :dataset_items
    has_many :project_datasets
    has_many :projects, through: :project_datasets
end
