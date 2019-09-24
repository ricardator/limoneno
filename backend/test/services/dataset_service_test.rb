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
      uploaded = DatasetService::Files.upload_pdf(mock_data)
      assert_equal({
        name: 'sample_file.pdf',
        dataset_id: 1,
        mime: 'application/pdf',
        text: nil,
        url: 'https://limoneno.s3.amazonaws.com/datasets/1/items/sample_file.pdf',
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
      uploaded = DatasetService::Files.upload_txt(mock_data)
      assert_equal({
        name: 'sample_txt.txt',
        dataset_id: 1,
        mime: 'text/plain',
        text: 'Lorem ipsum dolor sit amet',
        url: 'https://limoneno.s3.amazonaws.com/datasets/1/items/sample_txt.txt',
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

  # Tests for save txt files
  class UtilsDataset < Minitest::Test
    include FactoryBot::Syntax::Methods

    def test_params_to_item_fail_content
      exception = assert_raises Exception do
        DatasetService::Files.params_to_item({
          name: 'sample_txt.txt',
          dataset_id: 1,
          mime: 'text/plain',
          status: DatasetItem.statuses[:active]
        })
      end
      assert_equal('Data or URL required', exception.message)
    end

    def test_params_to_item_with_url
      params = DatasetService::Files.params_to_item({
        name: 'sample_txt.txt',
        dataset_id: 1,
        mime: 'text/plain',
        url: 'https://limoneno.s3.amazonaws.com/datasets/1/items/sample_txt.txt',
        status: DatasetItem.statuses[:active]
      })
      assert({
        dataset_id: 1,
        name: 'sample_txt.txt',
        text: nil,
        mime: 'text/plain',
        metadata: nil,
        url: 'https://limoneno.s3.amazonaws.com/datasets/1/items/sample_txt.txt',
        status: :active,
        stored: false
      }, params)
    end

    def test_params_to_item_with_data
      params = DatasetService::Files.params_to_item({
        name: 'sample_txt.txt',
        dataset_id: 1,
        mime: 'text/plain',
        data: 'FAKE_BASE64DATA',
        status: DatasetItem.statuses[:active]
      })
      assert({
        dataset_id: 1,
        name: 'sample_txt.txt',
        text: nil,
        mime: 'text/plain',
        metadata: nil,
        status: :active,
        stored: false
      }, params)
    end
  end

  def self.factory
    test = new DatasetServiceTest
    test.clean_database
    test.create_dataset
  end

  def self.result(data)
    {
      name: data[:name],
      dataset_id: data[:dataset_id],
      mime: data[:mime],
      text: data[:text],
      url: data[:url],
      status: data[:status]
    }
  end

  def create_dataset
    create(:dataset)
  end

  def clean_database
    DatabaseCleaner.strategy = :truncation, {:except => %w[	ar_internal_metadata]}
    DatabaseCleaner.clean
  end
end
