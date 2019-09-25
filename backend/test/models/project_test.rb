require 'test_helper'

class ProjectTest < Minitest::Test
  include FactoryBot::Syntax::Methods

  def test_free_pool_with_dataset_items
    project_dataset = create(:project_dataset, :with_item)

    free_pool_size = Project.free_pool(project_dataset.project_id).size

    assert_equal(1, free_pool_size)
  end

  def test_free_pool_without_dataset_items
    project_dataset = create(:project_dataset)

    free_pool_size = Project.free_pool(project_dataset.project_id).size

    assert_equal(0, free_pool_size)
  end
end
