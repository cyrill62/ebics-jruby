require 'java'
require 'rubygems'
require 'bundler/setup'
require 'jbundler'
Java::JavaSecurity::Security.addProvider Java::OrgBouncycastleJceProvider.BouncyCastleProvider.new
Java::OrgApacheXmlSecurity.Init.init
