require File.expand_path('../lib/ms_translate/version', __FILE__)

Gem::Specification.new do |spec|
  spec.version       = MsTranslate::VERSION
  spec.name          = "ms_translate"
  spec.summary       = "Microsoft Translator API Wrapper for Ruby"
  spec.description   = "MsTranslate is a wrapper for the Microsoft Translator API"

  spec.author       = ["Carlo Bertini"]
  spec.homepage      = "http://www.waydotnet.com"
  spec.email         = ["waydotnet@gmail.com"]

  spec.platform = Gem::Platform::RUBY
  spec.add_dependency('httparty')

  spec.add_development_dependency 'webmock'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'turn'
  spec.add_development_dependency 'rake'

  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  
  spec.require_paths = ['lib']
end
