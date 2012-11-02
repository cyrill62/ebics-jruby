require 'ebics/client'
module Ebics
  class Hbb < Client
    def download_certificates(user_id, product)
      user = users[user_id]

      session = Java::OrgKopiEbicsSession.EbicsSession.new(user, conf)
      session.product = product
      keymanager = Java::OrgKopiEbicsClient.KeyManagement.new(session)
      conf.trace_manager.trace_directory = conf.get_transfer_trace_directory(user)
      keymanager.sendHPB
    end

    def run(host_id, partner_id, user_id, password)
      pwd = Java::OrgKopiEbicsSecurity.UserPasswordHandler.new(user_id, password)

      load_user(
        Ebics::Client::URL_EBICS_SERVER,
        Ebics::Client::BANK_NAME,
        host_id,
        partner_id,
        user_id,
        pwd
      )

      product = Java::OrgKopiEbicsSession.Product.new('kopiLeft Dev 1.0', Java::JavaUtil.Locale::FRANCE, nil)
      download_certificates(user_id, product)
    end
  end
end
