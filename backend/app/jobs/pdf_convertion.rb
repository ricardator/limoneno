require 'services/midas_service'
class PdfConvertion
  include Sidekiq::Worker
  
  def perform(file, id)
    # Download file
    data = open(file).read
    # Send binary to midas
    text = MidasService::MidasClient.get_file_text(data)
    DatasetItem.update(id, {
      text: text,
      status: DatasetItem.statuses[:active]
    });
  rescue
    DatasetItem.update(id, {
      status: DatasetItem.statuses[:error]
    });
  end
end