require 'services/midas_service'
class PdfConvertion < Sidekiq::Worker
    queue_as :default
    
    def perform(file, dataset)
      # do da ting
      text = MidasService::MidasClient.get_file_text(file)
      DatasetItem.update(dataset[:id], {
        text: text,
        status: DatasetItem.statuses[:active]
      });
    rescue
      DatasetItem.update(dataset[:id], {
        status: DatasetItem.statuses[:error]
      });
    end
end