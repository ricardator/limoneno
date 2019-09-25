# frozen_string_literal: true

# Dataset Item model
class DatasetItem < ApplicationRecord
  enum status: { inactive: 0, active: 1, loading: 2, error: 3 }
  serialize :metadata, JSON

  belongs_to :dataset
  has_many :project_dataset_items
end
