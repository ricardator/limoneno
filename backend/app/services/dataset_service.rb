require 'services/midas_service'
module DatasetService 
  class Files

    def self.upload_pdf(file)
      # Verifications
      raise 'The mime type indicates a no pdf file' if file[:mime] != 'application/pdf'
      raise 'Need provided a content or file' if !file[:url] && !file[:data]
      stored = false
      # Requires AWS
      if file[:data]
        data = Base64.decode64(file[:data])
        file_saved = self.save_s3 file, data
        file[:url] = AwsService::S3.getURL(file_saved) if file_saved
        data = self.download_file(file[:url])
        stored = true if file_saved
      elsif file[:url]
        data = self.download_file(file[:url])
      end

      # 0: Archivo no cargado, 1: archivo cargado, 2: Archivo en proceso de carga
      dataset_item = {
        dataset_id: file[:dataset_id],
        name: file[:name],
        text: nil,
        mime: file[:mime],
        metadata: file[:metadata],
        url: file[:url],
        status: DatasetItem.statuses[:loading], 
        stored: stored
      }

      result = self.save_dataset([dataset_item])
      PdfConvertion.perform_async(file[:url], result[0][:id])
      result
    end

    def self.upload_txt(file)
      # Verifications
      raise 'The mime type indicates a no txt file' if file[:mime] != 'plain/text'
      raise 'Need provided a content or file' if !file[:url] && !file[:data]
      stored = false
      if file[:data]
        data = Base64.decode64(file[:data])
        file_saved = self.save_s3 file, data
        file[:url] = AwsService::S3.getURL(file_saved)
      elsif file[:url]
        data = self.download_file(file[:url])
      end
      
      result = self.save_dataset([{
        dataset_id: file[:dataset_id],
        name: file[:name],
        text: data,
        mime: file[:mime],
        metadata: file[:metadata],
        url: file[:url],
        status: DatasetItem.statuses[:active],
        stored: stored
      }])

      result
    end

    def self.upload_csv(file)
      true
    end

    def self.save_s3(file, data)
      if ActiveRecord::Type::Boolean.new.cast(ENV['AWS_SAVE'])
        key = "datasets/#{file[:dataset_id]}/items/#{file[:name]}"
        return AwsService::S3.upload_file(key, data)
      end
    rescue StandardError => ex
      puts "Hubo un error mientras se subia el archivo al bucket en S3"
      return nil
    end

    def self.save_dataset(file)
      result = []

      file.each do |item|
        ditem = DatasetItem.create({
          dataset_id: item[:dataset_id],
          name: item[:name],
          mime: item[:mime],
          text: item[:text],
          metadata: item[:metadata],
          url: item[:url],
          status: item[:status]
        });

        result.push(ditem) if ditem
      end

      result
    end

    def self.download_file(link)
      open(link).read
    end
  end
end