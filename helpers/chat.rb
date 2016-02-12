module ChatHelper

  def save_message(user, chat_id, content)
    chat = user.chats.get(chat_id)
    return nil if chat.nil?

    chat.messages.create(:user => user, :content => content)
  end

  def send_message(current_client, message, clients)
    clients.each do |client|
      signal = {
        message: message,
        right: client == current_client,
        author: message.user.username,
        type: 'message',
      }
      client.send(signal.to_json)
    end
  end

  def view_message(user, message)
    return nil if message.nil?

    message.viewers << user
    message.save

    message.destroy if (message.chat.users - message.viewers).empty?
  end

end
