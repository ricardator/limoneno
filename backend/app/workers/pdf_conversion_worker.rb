require 'services/midas_service'

class PdfConversionWorker
  include Sidekiq::Worker

  def perform(id)
    item = DatasetItem.find id
    text = MidasService::MidasClient.get_remote_file_text(item.url)
    item.update(text: text, status: :active)
  rescue
    item&.update(status: :error)
  end
end
