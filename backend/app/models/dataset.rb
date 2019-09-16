# frozen_string_literal: true

# Model that represents a set of data items
class Dataset < ApplicationRecord
  include ActiveModel::Serializers::JSON

  has_many :dataset_items
  has_many :project_datasets
  has_many :projects, through: :project_datasets
end
