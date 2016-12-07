require 'json'

class App < Sinatra::Base

  set :chats, {}

  get '/live/chat/:id' do
    restricred_area
    @user = current_user
    @chat_id = params[:id].to_i
    ws = Faye::WebSocket.new(request.env)

    ws.on(:open) do |event|
      settings.chats[@chat_id] ||= []
      settings.chats[@chat_id] << ws
    end

    ws.on(:message) do |event|
      data = JSON.parse(event.data)

      case data['type']
      when "message"
        message = save_message(@user, @chat_id, data['message'])
        send_message(ws, message, settings.chats[@chat_id]) if message.saved?
      when "view"
        view_message(@user, Message.get(data['message_id']))
      end

    end

    ws.on(:close) do |event|
      settings.chats[@chat_id].delete ws
      ws = nil
    end

    ws.rack_response
  end

end
