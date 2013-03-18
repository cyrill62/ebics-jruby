require 'thor'
require 'ebics'
require 'ebics/client'

module Ebics
  class Cli < Thor
    include Thor::Actions
    class_option :test, :aliases => '-t', :desc => 'do not send request to server (simulator mode)'
    class_option :bank_name, :aliases => '-b', :desc => "set bank name (default = #{Ebics::Client::BANK_NAME})"
    class_option :bank_url, :aliases => '-U', :desc => "set bank url (default = #{Ebics::Client::URL_EBICS_SERVER})"

    desc 'download_certs', 'download bank certificates'
    method_option :host_id, :aliases => '-h', :required => true
    method_option :partner_id, :aliases => '-p', :required => true
    method_option :user_id, :aliases => '-u', :required => true
    method_option :password, :aliases => '-P'
    def download_certs
      require_password
      require 'ebics/hbb'
      requestor = Ebics::Hbb.new
      requestor.run options
    end


    desc 'download FILE', 'download a file from the server'
    method_option :host_id, :aliases => '-h', :required => true
    method_option :partner_id, :aliases => '-p', :required => true
    method_option :user_id, :aliases => '-u', :required => true
    method_option :password, :aliases => '-P'
    def download(file)
      require_password
      require 'ebics/file/download'
      requestor = Ebics::File::Download.new
      requestor.run file, options
    end

    desc 'upload FILE', 'send a file to the server'
    method_option :host_id, :aliases => '-h', :required => true
    method_option :partner_id, :aliases => '-p', :required => true
    method_option :user_id, :aliases => '-u', :required => true
    method_option :password, :aliases => '-P'
    def upload(file)
      require_password
      require 'ebics/file/upload'
      requestor = Ebics::File::Upload.new
      requestor.run file, options
    end

    desc 'create_user [NAME] [EMAIL] [COUNTRY] [ORGANISATION]', 'create an user'
    method_option :host_id, :aliases => '-h', :required => true
    method_option :partner_id, :aliases => '-p', :required => true
    method_option :user_id, :aliases => '-u', :required => true
    method_option :password, :aliases => '-P'
    def create_user(name = 'pebics', email = 'pebics@domaine.fr', country = 'France', organization = 'Euro-Information')
      require_password
      require 'ebics/user'
      user = Ebics::User::Creator.new
      user.run(
        name,
        email,
        country,
        organization,
        true,
        options
      )
    end

    desc 'init_user', 'init an user on the server'
    method_option :host_id, :aliases => '-h', :required => true
    method_option :partner_id, :aliases => '-p', :required => true
    method_option :user_id, :aliases => '-u', :required => true
    method_option :password, :aliases => '-P'
    def init_user
      require_password
      require 'ebics/user'
      requestor = Ebics::User::Initiator.new
      requestor.run options
    end

    no_tasks do
      def require_password
        self.options = options.dup # unfreeze options
        self.options[:password] ||= ask('password:')
      end
    end
  end
end
