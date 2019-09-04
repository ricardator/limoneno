require 'grpc'
require 'proto/midas/midas_services_pb'

def test_single_call
  # message GetTextRequest {
  #     message Config {
  #         OcrConfig ocr = 1;
  #         string pages = 2;
  #         float min_image_ratio = 3;
  #     }
  #     bytes file = 1;
  #     InputFormat input_format = 2;
  #     OutputFormat output_format = 3;
  #     Config config = 4;
  # }
  stub = Midas::MidasService::Stub.new('midas.caseflow.lemontech.com:50999', :this_channel_is_insecure)

  url = 'https://civil.pjud.cl/CIVILPORWEB/DownloadFile.do?TIP_Documento=2&TIP_Archivo=3&COD_Opcion=1&COD_Tribunal=198&CRR_IdEscrito=73220229&CRR_IdDocEscrito=55086940';
  # file = open(url)

  request = Midas::GetTextRequest.new(
    file: open(url),
    input_format: Midas::InputFormat.PDF,
    output_format: Midas::OutputFormat.PLAIN_TEXT_WITH_SIGNATURES
  )
  response_object = stub.GetText(request)
  puts "GetText response: #{response_object}"
end
# test_single_call

# def call_midas
#   url = 'https://civil.pjud.cl/CIVILPORWEB/DownloadFile.do?TIP_Documento=2&TIP_Archivo=3&COD_Opcion=1&COD_Tribunal=198&CRR_IdEscrito=73220229&CRR_IdDocEscrito=55086940';
#   BufferedInputStream fileStream = FileUtils.downloadFile(url);

#   GetTextRequest request = GetTextRequest.newBuilder()
#       .setFile(ByteString.readFrom(fileStream))
#       .setInputFormat(InputFormat.PDF)
#       .setOutputFormat(OutputFormat.PLAIN_TEXT_WITH_SIGNATURES)
#       .build();

#   List<GetTextResponse> reply = midasService.getText(request);
#   System.out.println(reply.get(0).getText());
# end


# class MidasService < Midas::MidasService::Service

#   def GetText(get_text_request, _unused_call)
#     # GetTextRequest, GetTextResponse
#     # message GetTextRequest {
#     #     message Config {
#     #         OcrConfig ocr = 1;
#     #         string pages = 2;
#     #         float min_image_ratio = 3;
#     #     }
#     #     bytes file = 1;
#     #     InputFormat input_format = 2;
#     #     OutputFormat output_format = 3;
#     #     Config config = 4;
#     # }
#     pp '----- Calling GetText -----'
#     puts "Received URL snip request for #{snip_req.url}"

#     GetTextResponse
#     Snip::SnipResponse.new(url: snip_req.url)
#   end
# end
