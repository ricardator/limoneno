# frozen_string_literal: true

require 'services/midas_service'
require 'open-uri'

class DatasetServiceTest < Minitest::Test
  # Tests for save pdf files
  class PdfDataset < Minitest::Test
    def test_content_or_url_is_nil

      mock = {
        name: 'mock.pdf',
        dataset_id: 1,
        mime: 'application/pdf'
      }

      exception = assert_raises Exception do
        DatasetService::Files.upload_pdf(mock)
      end
      assert_equal('Need provided a content or file', exception.message)
    end

    def test_is_not_pdf

      mock = {
        name: 'mock.pdf',
        dataset_id: 1,
        mime: 'plain/txt'
      }

      exception = assert_raises Exception do
        DatasetService::Files.upload_pdf(mock)
      end
      assert_equal('The mime type indicates a no pdf file', exception.message)
    end
  end

  # Tests for save txt files
  class PdfDataset < Minitest::Test
    def test_content_or_url_is_nil

      mock = {
        name: 'mock.pdf',
        dataset_id: 1,
        mime: 'plain/text'
      }

      exception = assert_raises Exception do
        DatasetService::Files.upload_txt(mock)
      end
      assert_equal('Need provided a content or file', exception.message)
    end

    def test_is_not_txt

      mock = {
        name: 'mock.pdf',
        dataset_id: 1,
        mime: 'plain/txt'
      }

      exception = assert_raises Exception do
        DatasetService::Files.upload_txt(mock)
      end
      assert_equal('The mime type indicates a no txt file', exception.message)
    end
  end
end
