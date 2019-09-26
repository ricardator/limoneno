require 'test_helper'

class UserTest < Minitest::Test
  include FactoryBot::Syntax::Methods

  def test_to_json
    user = create(:user)

    user_json = user.to_json

    assert_instance_of(String, user_json)
  end
end
