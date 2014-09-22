# Generated by cucumber-sinatra. (2014-09-22 20:15:41 +0100)

ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), '..', '..', 'server.rb')

require 'capybara'
require 'capybara/cucumber'
require 'rspec'

Capybara.app = ClothingEStore

class ClothingEStoreWorld
  include Capybara::DSL
  include RSpec::Expectations
  include RSpec::Matchers
end

World do
  ClothingEStoreWorld.new
end
