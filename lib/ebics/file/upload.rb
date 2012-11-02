require 'ebics/client'
module Ebics
  module File
    class Upload < Ebics::Client
      def send_file(path, user, product)
        session = Java::OrgKopiEbicsSession.EbicsSession.new(user, conf)

        session.add_session_param 'FORMAT', 'pain.xxx.cfonb160.dct'
        session.add_session_param 'TEST', 'true'
        session.add_session_param 'EBCDIC', 'false'

        conf.trace_manager.trace_directory = conf.get_transfer_trace_directory(user)

        transfer_manager = Java::OrgKopiEbicsClient.FileTransfer.new(session)
puts("\033[01;33m#{path.inspect}\033[0m")
puts("\033[01;33m#{Java::OrgKopiEbicsSession.OrderType::FUL.inspect}\033[0m")
puts("\033[01;33m#{Java::OrgKopiEbicsIo::IOUtils.get_file_content(path).inspect}\033[0m")
        transfer_manager.send_file Java::OrgKopiEbicsIo::IOUtils.get_file_content(path), Java::OrgKopiEbicsSession.OrderType::FUL
      end

      def run(path, options)
        require_user_and_product(options)
        send_file(path, @user, @product)
      end
    end
  end
end
