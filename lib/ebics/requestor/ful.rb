require 'ebics/client'
module Ebics
  module Requestor
    class Ful < Ebics::Client
      def send_file(path, user_id, product)
        user = users[user_id]
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

      def run(path, host_id, partner_id, user_id, password)
        pwd = Java::OrgKopiEbicsSecurity.UserPasswordHandler.new(user_id, password)

        self.load_user(
          Ebics::Client::URL_EBICS_SERVER,
          Ebics::Client::BANK_NAME,
          host_id,
          partner_id,
          user_id,
          pwd
        )

        product = Java::OrgKopiEbicsSession.Product.new('kopiLeft Dev 1.0', Java::JavaUtil.Locale::FRANCE, nil)
        self.send_file(path, user_id, product)
      end
    end
  end
end
