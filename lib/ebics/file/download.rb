require 'ebics/client'
module Ebics
  module File
    class Download < Ebics::Client
      def fetch_file(path, user, product, test, date_start, date_end)
        session = Java::OrgKopiEbicsSession.EbicsSession.new(user, conf)

        session.add_session_param 'FORMAT', 'pain.xxx.cfonb160.dct'
        session.add_session_param 'TEST', 'true' if test
        session.product = product

        conf.trace_manager.trace_directory = conf.get_transfer_trace_directory(user)

        transfer_manager = Java::OrgKopiEbicsClient.FileTransfer.new(session)
        transfer_manager.fetch_file(
          Java::OrgKopiEbicsSession.OrderType::FDL,
          date_start,
          date_end,
          Java::JavaIo.FileOutputStream.new(path)
        )
      end

      def run(path, options)
        require_user_and_product(options)
        fetch_file(path, @user, @product, options[:test], options[:start], options[:end])
      end
    end
  end
end
