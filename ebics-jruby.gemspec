# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ebics/version', __FILE__)

Gem::Specification.new do |s|
  s.name          = 'ebics-jruby'
  s.version       = Ebics::VERSION
  s.authors       = ['Cyril LEPAGNOT']
  s.email         = ['cyril@lepagnot.fr']
  s.homepage      = 'https://github.com/cyrill62/ebics-jruby'
  s.summary       = 'an ebics client using org.kopi.ebics java lib'

  s.require_paths = ['lib']
  s.files         = `git ls-files`.split($\)
  s.executables   = s.files.grep(%r{^bin/}).map{ |f| File.basename(f) }

  s.test_files    = s.files.grep(%r{^(test|spec|features)/})

  s.add_dependency('thor', '>= 0.16.0')
  s.add_dependency('jbundler', '>= 0.3.2')
end
