class TextExtractionWorker
  include Sidekiq::Worker

  def perform(id)
    DatasetService::Files.extract_remote_text(id)
  end
end
