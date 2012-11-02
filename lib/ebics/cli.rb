require 'thor'
require 'ebics'

module Ebics
  class Cli < Thor
    include Thor::Actions
    class_option :test, :aliases => '-t', :desc => 'do not send request to server (simulator mode)'

    desc 'download_certs', 'send FDL request'
    method_option :host_id, :aliases => '-h', :required => true
    method_option :partner_id, :aliases => '-p', :required => true
    method_option :user_id, :aliases => '-u', :required => true
    def download_certs
      require 'ebics/hbb'
      requestor = Ebics::Hbb.new
      requestor.run(
        options[:host_id],
        options[:partner_id],
        options[:user_id],
        ask('password:')
      )
    end


    desc 'download FILE', 'send FDL request'
    method_option :host_id, :aliases => '-h', :required => true
    method_option :partner_id, :aliases => '-p', :required => true
    method_option :user_id, :aliases => '-u', :required => true
    def download(file)
      require 'ebics/file/download'
      requestor = Ebics::File::Download.new
      requestor.run(
        file,
        options[:host_id],
        options[:partner_id],
        options[:user_id],
        ask('password:')
      )
    end

    desc 'upload FILE', 'send FUL request'
    method_option :host_id, :aliases => '-h', :required => true
    method_option :partner_id, :aliases => '-p', :required => true
    method_option :user_id, :aliases => '-u', :required => true
    def upload(file)
      require 'ebics/file/upload'
      requestor = Ebics::File::Upload.new
      requestor.run(
        file,
        options[:host_id],
        options[:partner_id],
        options[:user_id],
        ask('password:')
      )
    end

    desc 'hbb FILE', 'send HBB request'
    def hbb(file)
      HBBRequestor.new(file)
    end

    desc 'create_user [NAME] [EMAIL] [COUNTRY] [ORGANISATION]', 'create an user'
    method_option :host_id, :aliases => '-h', :required => true
    method_option :partner_id, :aliases => '-p', :required => true
    method_option :user_id, :aliases => '-u', :required => true
    def create_user(name = 'pebics', email = 'pebics@domaine.fr', country = 'France', organization = 'Euro-Information')
      require 'ebics/user'
      user = Ebics::User::Creator.new
      user.run(
        Ebics::Client::URL_EBICS_SERVER,
        Ebics::Client::BANK_NAME,
        options[:host_id],
        options[:partner_id],
        options[:user_id],
        name,
        email,
        country,
        organization,
        true,
        ask('password:')
      )
    end

    desc 'init_user', 'init an user'
    method_option :host_id, :aliases => '-h', :required => true
    method_option :partner_id, :aliases => '-p', :required => true
    method_option :user_id, :aliases => '-u', :required => true
    def init_user
      require 'ebics/user'
      requestor = Ebics::User::Initiator.new
      requestor.run(
        options[:host_id],
        options[:partner_id],
        options[:user_id],
        ask('password:')
      )
    end
  end
end
