# frozen_string_literal: true

require 'grpc'
require 'proto/midas/midas_services_pb'
require 'open-uri'

module MidasService
  # Utils class to consume Midas OCR service
  class MidasClient
    MIDAS_HOST = 'midas.caseflow.lemontech.com:80'
    FILE_ENCODING = 'ASCII-8BIT'
    # http://www.africau.edu/images/default/sample.pdf
    # https://civil.pjud.cl/CIVILPORWEB/DownloadFile.do?TIP_Documento=2&TIP_Archivo=3&COD_Opcion=1&COD_Tribunal=198&CRR_IdEscrito=73220229&CRR_IdDocEscrito=55086940

    # For PDF files use 'file_type = Midas::InputFormat::PDF'
    def self.get_file_text(file, file_type = Midas::InputFormat::INPUT_FORMAT_AUTO)
      request = prepare_request(file, file_type)
      call_get_text(request)
    end

    # For PDF files use 'file_type = Midas::InputFormat::PDF'
    def self.get_remote_file_text(url, file_type = Midas::InputFormat::INPUT_FORMAT_AUTO)
      request = prepare_remote_request(url, file_type)
      call_get_text(request)
    end

    private_class_method def self.call_get_text(request)
      stub = Midas::MidasService::Stub.new(MIDAS_HOST, :this_channel_is_insecure)
      response_object = stub.get_text(request)
    end

    private_class_method def self.prepare_remote_request(url, file_type)
      set_default_buffer

      downloaded_document = URI.open(url)
      file = File.read(downloaded_document, encoding: FILE_ENCODING)

      prepare_request(file, file_type)
    end

    private_class_method def self.prepare_request(file, input_format)
      Midas::GetTextRequest.new(
        file: file,
        input_format: input_format,
        output_format: Midas::OutputFormat::PLAIN_TEXT_WITH_SIGNATURES
      )
    end

    # Sets default read buffer to 0 to force OpenURI to store it inside a TempFile.
    # If a file is small enough OpenURI returns StringIO instead of TempFile.
    # Maybe this should be inside an initializer
    private_class_method def self.set_default_buffer
      if OpenURI::Buffer.const_defined?('StringMax')
        OpenURI::Buffer.send(:remove_const, 'StringMax')
      end
      OpenURI::Buffer.const_set('StringMax', 0)
    end
  end
end
