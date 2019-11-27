require 'test_helper'

class ProjectTest < Minitest::Test
  include FactoryBot::Syntax::Methods

  def test_free_pool_with_dataset_items
    project = create(:project_dataset, :with_item).project

    free_pool_size = project.free_pool.size

    assert_equal(1, free_pool_size)
  end

  def test_free_pool_without_dataset_items
    project = create(:project_dataset).project

    free_pool_size = project.free_pool.size

    assert_equal(0, free_pool_size)
  end

  def test_with_dependencies
    project = create(:project_dataset, :with_item).project

    project = project.with_dependencies

    assert project.present?
  end
end
