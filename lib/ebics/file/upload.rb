require 'ebics/client'
module Ebics
  module File
    class Upload < Ebics::Client
      def send_file(path, user, product, format, test)
        session = Java::OrgKopiEbicsSession.EbicsSession.new(user, conf)

        session.add_session_param 'FORMAT', format
        session.add_session_param 'TEST', 'true' if test
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
        begin
          send_file(path, @user, @product, options[:format], options[:test])
        ensure
          serialize_user
        end
      end
    end
  end
end
