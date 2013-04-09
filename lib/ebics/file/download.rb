require 'ebics/client'
module Ebics
  module File
    class Download < Ebics::Client
      def fetch_file(path, user, product, format, test, date_start = Date.today.prev_day.prev_day.to_java, date_end = Date.today.to_java)
        session = Java::OrgKopiEbicsSession.EbicsSession.new(user, conf)

        session.add_session_param 'TEST', 'true' if test
        session.add_session_param 'FORMAT', format
        session.product = product

        conf.trace_manager.trace_directory = conf.get_transfer_trace_directory(user)

        transfer_manager = Java::OrgKopiEbicsClient.FileTransfer.new(session)
        transfer_manager.fetch_file(
          Java::OrgKopiEbicsSession.OrderType::FDL,
          java.util.Date.new(date_start),
          java.util.Date.new(date_end),
          Java::JavaIo.FileOutputStream.new(path)
        )
      end

      def run(path, options)
        require_user_and_product(options)
        begin
          fetch_file(path, @user, @product, options[:format], options[:test], options[:start], options[:end])
        ensure
          serialize_user
        end
      end
    end
  end
end
