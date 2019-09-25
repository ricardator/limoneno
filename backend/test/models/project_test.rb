require 'test_helper'

class ProjectTest < Minitest::Test
  include FactoryBot::Syntax::Methods

  def test_free_pool
    project_dataset = create(:project_dataset)

    items = Project.free_pool(project_dataset.project_id).size

    assert_equal(1, items)
  end
end
