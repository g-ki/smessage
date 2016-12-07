module ChatHelper
  def save_message(user, chat_id, msg)
    chat = user.chats.get(chat_id)
    return nil if chat.nil?

    query = {:user => user, :content => msg['content']}

    if msg['expire'] && msg['expire'].size > 1
      query[:expire_at] = DateTime.now + msg['expire'].to_f / (24*60)
    end

    chat.messages.create(query)
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
