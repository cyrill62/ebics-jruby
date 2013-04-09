require 'ebics/client'
module Ebics
  module User
    class Creator < Ebics::Client
      def create_user(
        bank_url,
        bank_name,
        host_id,
        partner_id,
        user_id,
        name,
        email,
        country,
        organization,
        saveCertificates,
        password)

        bank = Java::OrgKopiEbicsClient.Bank.new(Java::JavaNet::URL.new(bank_url), bank_name, host_id)
        conf.serialization_manager.serialize(bank)
        partner = Java::OrgKopiEbicsClient.Partner.new(bank, partner_id)
        conf.serialization_manager.serialize(partner)
        pwd = Java::OrgKopiEbicsSecurity.UserPasswordHandler.new(user_id, password)

        user = Java::OrgKopiEbicsClient.User.new(
          partner,
          user_id,
          name,
          email,
          country,
          organization,
          pwd
        )
        create_user_directories(user)

        user.save_user_certificates(conf.get_keystore_directory user) if saveCertificates

        sm = conf.serialization_manager
        [bank, partner, user].each do |o|
          sm.serialize o
        end

        load_sign_cert(user)

        load_letters(user)

        users[user_id] = user
      end

      def load_letters(user)
        lm = conf.letter_manager
        %w(a005 e002 x002).each do |format|
          letter = lm.send("create_#{format}_letter", user)
          letter.save(Java::JavaIo.FileOutputStream.new(
            File.join(conf.get_letters_directory(user), letter.name)
          ))
        end
      end

      def run(name, email, country, organization, saveCertificates, options)
        user = create_user(
          options[:bank_url],
          options[:bank_name],
          options[:host_id],
          options[:partner_id],
          options[:user_id],
          name,
          email,
          country,
          organization,
          saveCertificates,
          options[:password]
        )
        conf.serialization_manager.serialize(user)
      end
    end
  end
end
