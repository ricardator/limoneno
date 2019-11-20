require 'test_helper'

class DatasetItemTest < Minitest::Test
  include FactoryBot::Syntax::Methods

  def test_dataset_item_without_cleaning_text
    text = " Lorem ipsum dolor sit amet,   consectetur adipiscing elit.\n "
    dataset_item = create(:dataset_item, text: text)

    assert_equal(text, dataset_item.text)
  end

  def test_dataset_item_cleaning_text
    text = " Lorem ipsum dolor sit amet,   consectetur adipiscing elit.\n "
    dataset_item = create(:dataset_item, text: text)

    dataset_item.update(raw_text: text)
    cleaned_text = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.'

    assert_equal(cleaned_text, dataset_item.text)
  end
end
