# frozen_string_literal: true
require 'open-uri'
require "base64"
require 'database_cleaner'

class DatasetServiceTest < Minitest::Test
  include FactoryBot::Syntax::Methods

  def test_upload_mime
    mock = {
      name: 'mock.pdf',
      dataset_id: 1,
      mime: 'application/json'
    }
    exception = assert_raises Exception do
      DatasetService::Files.upload_item(mock)
    end
    assert_equal('Unknown format', exception.message)
  end


  # Tests for save pdf files
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

    def test_upload_pdf
      DatasetServiceTest.factory
      uploaded = DatasetService::Files.upload_item(mock_data)
      assert_equal({
        name: 'sample_file.pdf',
        dataset_id: 1,
        mime: 'application/pdf',
        raw_text: nil,
        text: nil,
        url: 'https://limoneno.s3.amazonaws.com/datasets/1/items/RANDOM_UUID/sample_file.pdf',
        status: 'loading',
      }, DatasetServiceTest.result(uploaded))
    end

    def mock_data
      mock_file_path = "#{Rails.root}/test/fixtures/files/sample_file.pdf"
      content = File.binread(mock_file_path)
      encoded = Base64.encode64(content)

      {
        name: 'sample_file.pdf',
        dataset_id: 1,
        mime: 'application/pdf',
        data: encoded
      }
    end

  end

  # Tests for save txt files
  class TxtDataset < Minitest::Test
    include FactoryBot::Syntax::Methods

    def test_content_or_url_is_nil

      mock = {
        name: 'mock.pdf',
        dataset_id: 1,
        mime: 'text/plain'
      }

      exception = assert_raises Exception do
        DatasetService::Files.upload_item(mock)
      end
      assert_equal('Data or URL required', exception.message)
    end

    def test_upload_txt
      DatasetServiceTest.factory
      uploaded = DatasetService::Files.upload_item(mock_data)
      assert_equal({
        name: 'sample_txt.txt',
        dataset_id: 1,
        mime: 'text/plain',
        raw_text: 'Lorem ipsum dolor sit amet',
        text: 'Lorem ipsum dolor sit amet',
        url: nil,
        status: 'active'
      }, DatasetServiceTest.result(uploaded))
    end

    def mock_data
      mock_file_path = "#{Rails.root}/test/fixtures/files/sample_txt.txt"
      content = File.binread(mock_file_path)
      encoded = Base64.encode64(content)

      {
        name: 'sample_txt.txt',
        dataset_id: 1,
        mime: 'text/plain',
        data: encoded
      }
    end
  end

  def self.factory
    test = new DatasetServiceTest
    test.clean_database
    test.create_dataset
  end

  def self.result(item)
    data = item.slice(:name, :dataset_id, :mime, :raw_text, :text, :url, :status).symbolize_keys
    regexp_uuid = /\b[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\b/
    data[:url] = data[:url]&.sub(regexp_uuid, 'RANDOM_UUID')
    data
  end

  def create_dataset
    create(:dataset)
  end

  def clean_database
    DatabaseCleaner.strategy = :truncation, {:except => %w[	ar_internal_metadata]}
    DatabaseCleaner.clean
  end
end
