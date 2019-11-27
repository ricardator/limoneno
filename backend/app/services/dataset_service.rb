require 'securerandom'
require 'services/midas_service'
require 'open-uri'

module DatasetService
  class Files
    VALID_TYPES = ['application/pdf', 'text/plain']

    def self.upload_item(params)
      case params[:mime]
      when 'application/pdf' then upload_pdf(params)
      when 'text/plain' then upload_txt(params)
      else raise 'Unknown format'
      end
    end

    def self.extract_remote_text(id)
      item = DatasetItem.find id
      text = case item.mime
             when 'application/pdf' then MidasService::MidasClient.get_remote_file_text(item.url)
             when 'text/plain' then URI.open(item.url).read
             end
      item.update(raw_text: text, status: :active)
    rescue
      item&.update(status: :error)
    end

    private

    def self.create_item(params)
      raise 'Data or URL required' if params[:url].blank? && params[:data].blank?

      item = {
        dataset_id: params[:dataset_id],
        name: params[:name],
        raw_text: nil,
        mime: params[:mime],
        metadata: params[:metadata],
        url: params[:url],
        status: :loading,
        stored: false
      }

      yield(item) if params[:data].present? && params[:url].blank?

      dataset_item = DatasetItem.create(item)
      TextExtractionWorker.perform_async(dataset_item.id) if item[:url].present?
      dataset_item
    end

    def self.upload_pdf(params)
      create_item(params) do |item|
        data = Base64.decode64(params[:data])
        item[:url] = save_s3(item, data)
        raise 'Failed to upload file' if item[:url].blank?
        item[:stored] = true
      end
    end

    def self.upload_txt(params)
      create_item(params) do |item|
        item[:raw_text] = Base64.decode64(params[:data])
        item[:status] = :active
      end
    end

    def self.save_s3(item, data)
      key = "datasets/#{item[:dataset_id]}/items/#{SecureRandom.uuid}/#{item[:name]}"
      AwsService::S3.upload_file(key, data)
    rescue StandardError => ex
      puts "Hubo un error mientras se subia el archivo al bucket en S3"
      return nil
    end
  end
end
