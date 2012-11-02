module Ebics
  class Client
    attr_accessor :users, :partners, :banks, :conf

    BANK_NAME = 'VALERIAN'
    URL_EBICS_SERVER = 'https://server-ebics.webank.fr:28103/WbkPortalFileTransfert/EbicsProtocol'

    def initialize
      self.conf = Java::OrgKopiEbicsSession.DefaultConfiguration.new
      self.users = {}
      self.banks = {}
      self.partners = {}
      messages.locale = conf.locale

      conf.init
    end

    def messages
      Java::OrgKopiEbicsMessages.Messages
    end

    def t(name, *params)
      messages.get_string(name, Java::OrgKopiEbicsUtils.Constants.APPLICATION_BUNDLE_NAME)
    end

    def log(name, *params)
      conf.logger.info t(name, *params)
    end

    def create_user_directories(user)
      log 'user.create.directories', user.user_id

      %w(get_user_directory
        get_transfer_trace_directory
        get_keystore_directory
        get_letters_directory).each do |dir|
        FileUtils.mkdir conf.send(dir, user)
      end
    end

    def create_bank(url, name, host_id)
      banks[host_id] = Java::OrgKopiEbicsClient.Bank.new(Java::JavaNet::URL.new(url), name, host_id)
    end

    def create_partner(bank, id)
      partners[id] = Java::OrgKopiEbicsClient.Partner.new(bank, id)
    end

    def load_user(bank_url, bank_name, host_id, partner_id, user_id, password)
      #begin
        bank = create_bank(bank_url, bank_name, host_id)
        partner = create_partner(bank, partner_id)
        users[user_id] = @user = Java::OrgKopiEbicsClient.User.new(partner, conf.serialization_manager.deserialize(user_id), password)
      #rescue
      #  log 'user.load.error'
      #end
    end

    def require_user(options)
      pwd = Java::OrgKopiEbicsSecurity.UserPasswordHandler.new(options[:user_id], options[:password])

      load_user(
        options[:bank_url] || URL_EBICS_SERVER,
        options[:bank_name] || BANK_NAME,
        options[:host_id],
        options[:partner_id],
        options[:user_id],
        pwd
      )
    end

    def require_product(options)
      @product = Java::OrgKopiEbicsSession.Product.new((options[:product_name] || 'kopiLeft Dev 1.0'), Java::JavaUtil.Locale::FRANCE, nil)
    end

    def require_user_and_product(options)
      require_user options

      require_product options
    end
  end
end
