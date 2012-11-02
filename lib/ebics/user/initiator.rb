require 'ebics/client'
module Ebics
  module User
    class Initiator < Ebics::Client
      def send_init_request(user, product)
        return if user.initialized?
        session = Java::OrgKopiEbicsSession.EbicsSession.new(user,conf)
        session.product = product
        keymanager = Java::OrgKopiEbicsClient.KeyManagement.new(session)
        conf.trace_manager.trace_directory = conf.get_transfer_trace_directory(user)
        keymanager.sendINI nil
        user.initialized = true
      end

      def send_hia_request(user, product)
        return if user.initialized_hia?
        session = Java::OrgKopiEbicsSession.EbicsSession.new(user,conf)
        session.product = product
        keymanager = Java::OrgKopiEbicsClient.KeyManagement.new(session)
        conf.trace_manager.trace_directory = conf.get_transfer_trace_directory(user)
        keymanager.sendHIA nil
        user.initialized_hia = true
      end

      def run(options)
        require_user_and_product(options)
        send_init_request(@user, @product)
        send_hia_request(@user, @product)
      end

    end
  end
end
