module AwsService
  class S3
    def self.config
      s3 = Aws::S3::Resource.new
      @bucket = s3.bucket(ENV['AWS_BUCKET'])
    end

    def self.list_files()
      self.config
      @bucket.objects
    end

    def self.upload_file(key, body)
      self.config
      object = @bucket.put_object({
          body: body,
          key: key,
      })
      object.public_url
    end

    def self.delete_file(key)
      self.config
      @bucket.delete_objects({
        delete: {
          objects: [{
            key: key
          }]
        }
      })
    end
  end
end
