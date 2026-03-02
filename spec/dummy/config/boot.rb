ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __dir__)

require "bundler/setup" # Set up gems listed in the Gemfile.

# In newer rubies "logger" is now a gem
# However despite setting a "require" on the Gemfile for 6.1, I still need to require it explicitly
require "logger"
