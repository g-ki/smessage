require 'digest'

class App < Sinatra::Base

  before '/chat' do
    restricred_area
    @user = current_user
  end

  before '/chat/*' do
    restricred_area
    @user = current_user
  end

  get '/chat' do
    last_chat = current_user.chats.first(:order => [:updated_at.desc])
    redirect "/chat/#{last_chat.id}" if last_chat

    redirect "/connect"
  end

  get '/chat/new' do
    @user = current_user
    @header = "New Message"
    erb :'messenger/new', layout: :"layouts/messenger"
  end

  post '/chat/new' do
    redirect '/chat/new' if params[:friends].size < 1
    @user = current_user

    users = @user.friends.all(:id => params[:friends]) + @user
    if users.size == 2
      all_chats = (users[0].chats & users[1].chats)
      all_chats.each{ |c| redirect "/chat/#{c.id}" if c.users.size == 2 }
    end

    chat = Chat.new
    chat.users.concat(users)
    chat.save
    redirect "/chat/#{chat.id}" if chat.saved?
    redirect '/chat/new'
  end

  get '/chat/:id' do
    @user = current_user

    @chat = @user.chats.get(params[:id])

    redirect '/chat/new' unless @chat

    @header = @chat.name(@user)
    erb :'messenger/chat', layout: :"layouts/messenger"
  end

  delete '/chat/:id' do
    chat = @user.chats.get(params[:id])
    chat.destroy if chat
    redirect '/chat'
  end

  post '/chat/:id/message' do
    @user = current_user
    @chat = @user.chats.get params[:id]

    redirect "/chat" if @chat.nil?

    message = Message.new(:content => params[:message])
    message.user = @user
    message.chat = @chat
    message.save
    @chat.update(:updated_at => DateTime.now )

    redirect "/chat/#{params[:id]}"
  end

  post "/chat/:id/upload" do
    @user = current_user
    @chat = @user.chats.get params[:id]

    redirect "/chat" if @chat.nil?

    filename = Digest::MD5.hexdigest (@user.id.to_s + params['file'][:filename])
    filetype = File.extname(params['file'][:filename])
    filename += filetype
    File.open("./public/img/#{filename}", 'wb') do |f|
      f.write(params[:file][:tempfile].read)
    end

    message = Message.new(:content => filename, :type => 'image')
    message.user = @user
    message.chat = @chat
    message.save
    @chat.update(:updated_at => DateTime.now )

    "Uploaded."
  end

end
