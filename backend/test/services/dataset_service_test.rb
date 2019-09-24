# frozen_string_literal: true
require 'open-uri'
require "base64"
require 'database_cleaner'

class DatasetServiceTest < Minitest::Test
  include FactoryBot::Syntax::Methods
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
      }, DatasetServiceTest.result(uploaded)[0])
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
        DatasetService::Files.upload_txt(mock)
      end
      assert_equal('Need provided a content or file', exception.message)
    end

    def test_is_not_txt

      mock = {
        name: 'mock.pdf',
        dataset_id: 1,
        mime: 'application/json'
      }

      exception = assert_raises Exception do
        DatasetService::Files.upload_txt(mock)
      end
      assert_equal('The mime type indicates a no txt file', exception.message)
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
      }, DatasetServiceTest.result(uploaded)[0])
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

    def test_save_dataset
      DatasetServiceTest.factory
      dataset = DatasetService::Files.save_dataset([{
        name: 'sample_txt.txt',
        dataset_id: 1,
        mime: 'text/plain',
        text: 'Lorem ipsum dolor sit amet',
        url: 'https://limoneno.s3.amazonaws.com/datasets/1/items/sample_txt.txt',
        status: DatasetItem.statuses[:active]
      }])
      assert_equal([{
        name: 'sample_txt.txt',
        dataset_id: 1,
        mime: 'text/plain',
        text: 'Lorem ipsum dolor sit amet',
        url: 'https://limoneno.s3.amazonaws.com/datasets/1/items/sample_txt.txt',
        status: 'active'
      }],DatasetServiceTest.result(dataset))
    end
  end

  def self.factory
    test = new DatasetServiceTest
    test.clean_database
    test.create_dataset
  end

  def self.result(data)
    result = []

    data.each do |item|
      result.push({
        name: item[:name],
        dataset_id: item[:dataset_id],
        mime: item[:mime],
        text: item[:text],
        url: item[:url],
        status: item[:status]
      })
    end

    result
  end

  def create_dataset
    create(:dataset)
  end

  def clean_database
    DatabaseCleaner.strategy = :truncation, {:except => %w[	ar_internal_metadata]}
    DatabaseCleaner.clean
  end
end
