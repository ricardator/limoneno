class PdfConvertion < ActiveJob::Base
    queue_as :default
    
    def perform(file, metadata, dataset_item)
      # do da ting
    end
end