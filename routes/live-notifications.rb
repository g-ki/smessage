class App < Sinatra::Base

  connections = []

  get '/live/notifications/connect', provides: 'text/event-stream' do
    stream :keep_open do |out|
      connections << out

      out.callback { connections.delete(out) }
    end
  end

  post '/live/notifications/push' do
    notification = params.to_json

    connections.each { |out| out << "data: #{notification}\n\n" }

    "message sent"
  end

end
