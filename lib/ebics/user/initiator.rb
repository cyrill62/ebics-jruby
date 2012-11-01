require 'ebics/client'
module Ebics
  module User
    class Initiator < Ebics::Client
      def send_init_request(user_id, product)
        user = users[user_id]
        return if user.initialized?
        session = Java::OrgKopiEbicsSession.EbicsSession.new(user,conf)
        session.product = product
        keymanager = Java::OrgKopiEbicsClient.KeyManagement.new(session)
        conf.trace_manager.trace_directory = conf.get_transfer_trace_directory(user)
        keymanager.sendINI nil
        user.initialized = true
      end

      def send_hia_request(user_id, product)
        user = users[user_id]
        return if user.initialized_hia?
        session = Java::OrgKopiEbicsSession.EbicsSession.new(user,conf)
        session.product = product
        keymanager = Java::OrgKopiEbicsClient.KeyManagement.new(session)
        conf.trace_manager.tracer_directory = conf.get_transfer_trace_directory(user)
        keymanager.sendHIA nil
        user.initialized_hia = true
      end

      def run(host_id, partner_id, user_id, password)
        product = Java::OrgKopiEbicsSession.Product.new('kopiLeft Dev 1.0', Java::JavaUtil.Locale::FRANCE, nil)
        pwd = Java::OrgKopiEbicsSecurity.UserPasswordHandler.new(user_id, password)
        
        self.load_user(
          Ebics::Client::URL_EBICS_SERVER,
          Ebics::Client::BANK_NAME,
          host_id,
          partner_id,
          user_id,
          pwd
        )

        send_init_request(user_id, product)
        send_hia_request(user_id, product)
      end

    end
  end
end
