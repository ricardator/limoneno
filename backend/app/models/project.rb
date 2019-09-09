# frozen_string_literal: true

class Project < ApplicationRecord
  has_many :project_datasets
  has_many :project_users
  has_many :project_dataset_items
  has_many :users, through: :project_users
  has_many :datasets, through: :project_datasets

  def self.project_with_dependencies(id)
    project = Project.where(
      id: id
    ).includes(:users)
    .includes(:datasets).first

    tmp = project.attributes
    tmp[:datasets] = project.datasets
    tmp[:users] = project.users

    tmp[:assignated] = ProjectDatasetItem.where(
      project_id: project.id,
      status: [0, -1]
    ).count(:id)

    tmp[:assignated_done] = ProjectDatasetItem.where(
      project_id: project.id,
      status: 1
    ).count(:id)

    tmp[:free_pool_done] = ProjectDatasetItem.where(
      project_id: project.id,
      status: 2
    ).count(:id)

    tmp[:free_pool] = Project.where(
      id: project.id
    ).joins(:datasets)
    .joins('INNER JOIN dataset_items ON datasets.id = dataset_items.dataset_id')
    .joins('LEFT OUTER JOIN project_dataset_items ON project_dataset_items.project_id = projects.id AND dataset_items.id = project_dataset_items.dataset_item_id')
    .where('project_dataset_items.id IS NULL').count('*')

    tmp
  end
end
