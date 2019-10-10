# frozen_string_literal: true

class Project < ApplicationRecord
  serialize :entities, JSON
  serialize :clasifications, JSON

  has_many :project_datasets, dependent: :destroy
  has_many :project_users, dependent: :destroy
  has_many :project_dataset_items, dependent: :destroy
  has_many :users, through: :project_users
  has_many :datasets, through: :project_datasets

  def self.with_dependencies(id)
    project = Project.includes(:users, :datasets).find(id)

    tmp = project.attributes
    tmp[:datasets] = project.datasets
    tmp[:users] = project.users

    project_dataset_items = ProjectDatasetItem.where(project_id: id, status: 1).to_a

    tmp[:assignated] = project_dataset_items.count { |item| item.status.zero? || item.status == 1 }
    tmp[:assignated_done] = project_dataset_items.count { |item| item.status == 1 }
    tmp[:free_pool_done] = project_dataset_items.count { |item| item.status == 2 }
    tmp[:free_pool] = Project.free_pool(id).size

    tmp
  end

  def self.free_pool(id)
    Project.where(id: id)
           .joins(:datasets)
           .joins('INNER JOIN dataset_items ON datasets.id = dataset_items.dataset_id')
           .joins('LEFT OUTER JOIN project_dataset_items ON project_dataset_items.project_id = projects.id AND dataset_items.id = project_dataset_items.dataset_item_id')
           .where('project_dataset_items.id IS NULL')
           .where('dataset_items.status = 1')
           .select('dataset_items.id, datasets.id AS dataset').to_a
  end
end
