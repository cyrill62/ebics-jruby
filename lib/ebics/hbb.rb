require 'ebics/client'
module Ebics
  class Hbb < Client
    def download_certificates(user, product)
      session = Java::OrgKopiEbicsSession.EbicsSession.new(user, conf)
      session.product = product
      keymanager = Java::OrgKopiEbicsClient.KeyManagement.new(session)
      conf.trace_manager.trace_directory = conf.get_transfer_trace_directory(user)
      keymanager.sendHPB
    end

    def run(options)
      require_user_and_product(options)
      download_certificates(@user, @product)
      serialize_user
    end
  end
end
