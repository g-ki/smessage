require_relative 'authentication'

class App < Sinatra::Base
  helpers Authentication
end
