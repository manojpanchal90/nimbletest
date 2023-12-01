# spec/support/vcr_setup.rb
require 'vcr'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/cassettes'
  config.hook_into :webmock # or :faraday or any other HTTP library you are using
end