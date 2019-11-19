# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :project_datasets, dependent: :destroy
  has_many :project_users, dependent: :destroy
  has_many :project_dataset_items, dependent: :destroy
  has_many :users, through: :project_users
  has_many :datasets, through: :project_datasets

  def self.with_dependencies(id)
    find(id).with_dependencies
  end

  def with_dependencies
    pdi_status = project_dataset_items.group(:status).count
    attributes.merge(
      datasets: datasets,
      users: users,
      assignated: (pdi_status[0] || 0) + (pdi_status[1] || 0),
      assignated_done: pdi_status[1],
      free_pool_done: pdi_status[2],
      free_pool: free_pool.size
    )
  end

  def free_pool(user_id = nil)
    pdi = project_dataset_items
    pdi = project_dataset_items.where(user_id: user_id) if user_id
    free_item = DatasetItem.where(dataset_id: project_datasets.select(:dataset_id), status: 1)
                           .where.not(id: pdi.select(:dataset_item_id))
  end
end
