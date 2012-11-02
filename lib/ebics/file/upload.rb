require 'ebics/client'
module Ebics
  module File
    class Upload < Ebics::Client
      def send_file(path, user, product)
        session = Java::OrgKopiEbicsSession.EbicsSession.new(user, conf)

        session.add_session_param 'FORMAT', 'pain.xxx.cfonb160.dct'
        session.add_session_param 'TEST', 'true'
        session.add_session_param 'EBCDIC', 'false'
        session.product = product

        conf.trace_manager.trace_directory = conf.get_transfer_trace_directory(user)

        transfer_manager = Java::OrgKopiEbicsClient.FileTransfer.new(session)
        transfer_manager.send_file(
          Java::OrgKopiEbicsIo::IOUtils.get_file_content(path),
          Java::OrgKopiEbicsSession.OrderType::FUL
        )
      end

      def run(path, options)
        require_user_and_product(options)
        send_file(path, @user, @product)
      end
    end
  end
end
