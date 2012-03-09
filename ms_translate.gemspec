# -*- encoding: utf-8 -*-
require File.expand_path('../lib/ms_translate/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Carlo Bertini"]
  gem.email         = ["waydotnet@gmail.com"]
  gem.description   = "MsTranslate is a wrapper for the Microsoft Translator API"
  gem.summary       = "Microsoft Translator API Wrapper for Ruby"
  gem.homepage      = "http://www.waydotnet.com"

  gem.add_dependency('httparty')


  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "ms_translate"
  gem.require_paths = ["lib"]
  gem.version       = MsTranslate::VERSION
end
