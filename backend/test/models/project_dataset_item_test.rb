require 'test_helper'

class ProjectDatasetItemTest < Minitest::Test
  include FactoryBot::Syntax::Methods

  def test_create_users_pool
    project_id = create(:project_dataset, :with_item).project_id
    user = create(:user)
    free_pool_size = Project.free_pool(project_id).size
    users_pool = Hash[user.id, free_pool_size]

    ProjectDatasetItem.create_users_pool(users_pool, project_id)
    user_pool = ProjectDatasetItem.where(user_id: user.id, project_id: project_id).count

    assert_equal(users_pool[user.id], user_pool)
  end
end
