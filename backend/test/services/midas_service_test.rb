# frozen_string_literal: true

require 'services/midas_service'

class MidasServiceTest < Minitest::Test

  class GetRemoteFileTextTests < Minitest::Test
    # setup do
    #   @variable = something
    # end

    def test_url_required_empty
      url = ''

      exception = assert_raises Exception do
        ::MidasService::MidasClient.get_remote_file_text(url)
      end
      assert_equal('URL not provided.', exception.message)
    end

    def test_url_required_nil
      url = nil

      exception = assert_raises Exception do
        ::MidasService::MidasClient.get_remote_file_text(url)
      end
      assert_equal('URL not provided.', exception.message)
    end
  end
end
