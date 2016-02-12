require_relative 'authentication'
require_relative 'chat'

class App < Sinatra::Base
  helpers Authentication
  helpers ChatHelper
end
