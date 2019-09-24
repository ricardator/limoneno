# frozen_string_literal: true

require 'services/midas_service'
require 'open-uri'

class DatasetServiceTest < Minitest::Test
  class PdfDataset < Minitest::Test
    # Tests for save pdf files
    def test_content_or_url_is_nil

      mock = {
        name: 'mock.pdf',
        dataset_id: 1,
        mime: 'application/pdf'
      }

      exception = assert_raises Exception do
        DatasetService::Files.upload_item(mock)
      end
      assert_equal('Data or URL required', exception.message)
    end

    # Tests for save txt files
    def test_content_or_url_is_nil

      mock = {
        name: 'mock.pdf',
        dataset_id: 1,
        mime: 'plain/text'
      }

      exception = assert_raises Exception do
        DatasetService::Files.upload_item(mock)
      end
      assert_equal('Data or URL required', exception.message)
    end

    def test_is_not_txt

      mock = {
        name: 'mock.pdf',
        dataset_id: 1,
        mime: 'plain/txt'
      }

      exception = assert_raises Exception do
        DatasetService::Files.upload_item(mock)
      end
      assert_equal('Unknown format', exception.message)
    end
  end
end
