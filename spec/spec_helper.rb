#we need the actual library file
# require_relative '../lib/ms_translate'
# For Ruby < 1.9.3, use this instead of require_relative
require(File.expand_path('../../lib/ms_translate', __FILE__))

#dependencies
require 'minitest/autorun'
require 'webmock/minitest'
require 'vcr'
require 'turn'

Turn.config do |c|
  # :outline  - turn's original case/test outline mode [default]
  c.format  = :outline
  # turn on invoke/execute tracing, enable full backtrace
  # c.trace   = true
  # use humanized test names (works only with :outline format)
  c.natural = true
end

# VCR config
VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/ms_translate_cassettes'
  c.hook_into :webmock # or :fakeweb
  c.allow_http_connections_when_no_cassette = false
  c.default_cassette_options = {
     :record => :once
  }
end
