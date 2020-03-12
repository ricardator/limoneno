# frozen_string_literal: true

class ProjectDatasetItem < ApplicationRecord
  belongs_to :project
  belongs_to :user
  belongs_to :dataset
  belongs_to :dataset_item

  # Statuts meaning
  # 0  Asignado pero no revisado
  # 1  asignados
  # 2  auto asignados
  # -1  multiple actuacion

  def self.create_users_pool(users_pool, project_id)
    free_pool = Project.find(project_id).free_pool.pluck(:id, :dataset_id)
    users_pool.each do |user_id, pool|
      user_pool = free_pool.shift(pool)
      user_pool.each do |item|
        ProjectDatasetItem.create(
          user_id: user_id,
          project_id: project_id,
          status: 0,
          dataset_id: item[1],
          dataset_item_id: item[0]
        )
      end
    end
  end
end
