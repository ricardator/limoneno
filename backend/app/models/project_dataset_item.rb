class ProjectDatasetItem < ApplicationRecord
  belongs_to :project
  belongs_to :user
  belongs_to :dataset
  belongs_to :dataset_item

  def self.create_users_pool(users_pool, project_id)
    free_pool = Project.free_pool(project_id)
    users_pool.each do |user_id, pool|
      user_pool = free_pool.shift(pool)
      user_pool.each do |item|
        ProjectDatasetItem.create(
          user_id: user_id,
          project_id: project_id,
          status: 0,
          dataset_id: item.dataset,
          dataset_item_id: item.id
        )
      end
    end
  end
end
