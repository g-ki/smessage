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

  #DataMapper::setup(:default, 'sqlite::memory:')
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/test.db")
  DataMapper.finalize.auto_upgrade!

  def fake_user
    {:username => 'fake_user', :password => 'fake_pass'}
  end

  def rand_user
    {
      :username => 'qwertyuiopasdfghjklzxcvbnm'.each_char.to_a.shuffle.join(""),
      :password => 'password',
    }
  end
end
