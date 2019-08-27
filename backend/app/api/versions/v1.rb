module Versions
    # V1 API
    class V1 < Grape::API
      version 'v1', using: :path
      format :json
      prefix :api

      mounted do
        V1.info "This API was mounted at: #{configuration[:endpoint_name]}"
    
        get configuration[:endpoint_name] do
          configuration[:configurable_response]
        end
      end

      def self.info api
        puts api
      end
  
      mount V1::Users
      mount V1::Datasets
      mount V1::Projects
    end
  end