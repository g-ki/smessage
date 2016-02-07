require 'bundler/setup'
require 'sinatra'
require 'data_mapper'
require 'rack-flash'


require_relative 'models/init'
require_relative 'helpers/init'
require_relative 'routes/init'

class App < Sinatra::Base
  enable :sessions
  set :session_secret, 'YnhAZX2PF5gFlr9Gv6UufwbzSJ06YbNNE7HeMhf3jbRjXPm1W'

  use Rack::Flash

  configure do
    set :app_file, __FILE__
  end

  get '/' do
    if not logged_in?
      erb :'website/home', layout: :"layouts/default"
    else
      @user = current_user
      @header = @user.username
      erb :'messenger/chat', layout: :"layouts/messenger"
    end
  end

end
