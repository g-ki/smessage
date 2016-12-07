require 'bundler/setup'
require 'sinatra'
require 'tilt/erb'
require 'data_mapper'
require 'rack-flash'
require 'thin'
require 'faye/websocket'


require_relative 'models/init'
require_relative 'helpers/init'
require_relative 'routes/init'

class App < Sinatra::Base
  enable :sessions
  set :session_secret, 'YnhAZX2PF5gFlr9Gv6UufwbzSJ06YbNNE7HeMhf3jbRjXPm1W'

  use Rack::Flash

  before do
    # clean up database
    to_destroy = Message.all - Message.all_valid
    to_destroy.destroy
  end

  configure do
    set :app_file, __FILE__
  end

  get '/' do
    if not logged_in?
      erb :'website/home', layout: :"layouts/default"
    else
      redirect '/chat'
    end
  end
end
