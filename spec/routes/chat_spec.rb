require_relative '../spec_helper'

describe "Chat" do

  context "when user is logged out" do
    it "should be restricted from chat '/chat/*'" do
      get '/chat'
      expect(last_response.redirection?).to be true
      expect(last_response.location).to eq("http://example.org/login")

      get '/chat/*'
      expect(last_response.redirection?).to be true
      expect(last_response.location).to eq("http://example.org/login")
    end
  end

  context "when user is logged in" do

    before(:each) do
      User.all.destroy
      Chat.all.destroy

      @user = User.create fake_user
      @friendA = make_friend
      @friendB = make_friend

      get "/logout"
      post "/login", fake_user
    end

    describe "/chat" do
      it "should redirec to '/connect' if user has no chats" do
        get '/chat'

        expect(last_response.redirection?).to be true
        expect(last_response.location).to eq("http://example.org/connect")
      end

      it "should redirec to last active chat" do
        chat = @user.chats.create
        @user.save
        get '/chat'

        expect(last_response.redirection?).to be true
        expect(last_response.location).to eq("http://example.org/chat/#{chat.id}")
      end
    end

    describe "/chat/new" do

      context "direct chat (2 users)" do

        it "should be created new" do
          post '/chat/new', {friends:[@friendA.id]}

          chat = @user.chats.last
          chat.users.each do |user|
            expect([@user, @friendA]).to include(user)
          end
        end

      end

      context "group chat (more then 2 users)" do
        it "make group chat" do
          post '/chat/new', {friends: [@friendA.id, @friendB.id]}

          chat_id =  last_response.location.split('/').last.to_i
          chat = @user.chats.get(chat_id)

          expect(chat).to be
          chat.users.each do |user|
            expect([@user, @friendA, @friendB]).to include(user)
          end
          expect(chat.group?).to be true
        end
      end
    end

    describe "/chat/delete" do
      it "remove" do
        post '/chat/new', {friends: [@friendA.id, @friendB.id]}
        chat_id = last_response.location.split('/').last.to_i

        delete "/chat/#{chat_id}"

        expect(Chat.get(chat_id)).to be nil
        expect(User.all.count).to eq 3
      end
    end

    describe "messages" do

      it "are send and listed" do
        post '/chat/new', {friends: [@friendA.id, @friendB.id]}
        chat_id = last_response.location.split('/').last.to_i
        chat = @user.chats.get(chat_id)

        post "/chat/#{chat_id}/message", {:message => "Hey, I'm @user."}

        expect(@user.messages.first(:content => "Hey, I'm @user.")).to be
        expect(chat.messages.first(:content => "Hey, I'm @user.")).to be

        get "/chat/#{chat_id}"
        expect(last_response.body).to include "Hey, I'm @user."
      end

    end

  end
end
