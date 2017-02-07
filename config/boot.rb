ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

#switched out these two lines due to Rails upgrade to 4.2.0
require 'bundler/setup' # Set up gems listed in the Gemfile.
#require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])
