require 'securerandom'

module DatasetService
  class Files
    VALID_TYPES = ['application/pdf', 'plain/text']

    def self.upload_item(params)
      case params[:mime]
      when 'application/pdf' then upload_pdf(params)
      when 'plain/text' then upload_txt(params)
      else raise 'Unknown format'
      end
    end

    private

    def self.params_to_item(params)
      raise 'Data or URL required' if params[:url].blank? && params[:data].blank?

      {
        dataset_id: params[:dataset_id],
        name: params[:name],
        text: nil,
        mime: params[:mime],
        metadata: params[:metadata],
        url: params[:url],
        status: :loading,
        stored: false
      }
    end

    def self.upload_pdf(params)
      item = params_to_item(params)

      # Requires AWS
      if params[:data].present? && params[:url].blank?
        data = Base64.decode64(params[:data])
        item[:url] = save_s3(item, data)
        raise 'Failed to upload file' if item[:url].blank?
        item[:stored] = true
      end

      dataset_item = DatasetItem.create(item)
      PdfConversionWorker.perform_async(dataset_item.id)
      dataset_item
    end

    def self.upload_txt(params)
      item = params_to_item(params)
      item[:text] = Base64.decode64(params[:data])
      item[:status] = :active

      DatasetItem.create(item)
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
