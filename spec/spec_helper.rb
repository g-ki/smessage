require 'rack/test'
require 'rspec'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../app.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app() App.new end
end

RSpec.configure do |config|
  config.include RSpecMixin

  DataMapper::setup(:default, 'sqlite::memory:')
  DataMapper.finalize.auto_upgrade!

  def fake_user
    {:username => 'foobar', :password => 'pass'}
  end
end
