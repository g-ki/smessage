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

    before(:all) do
      User.all.each { |user| user.destroy }
      @user = User.create fake_user
      post "/login", fake_user
    end

    describe "/chat" do
      it "should redirec to '/connect' if user has no chats" do
        @user.chats.all.destroy
        get '/chat'

        expect(last_response.redirection?).to be true
        expect(last_response.location).to eq("http://example.org/connect")
      end

      it "should redirec to last active chat" do
        @user.chats.all.destroy
        chat = @user.chats.create
        @user.save
        get '/chat'

        expect(last_response.redirection?).to be true
        expect(last_response.location).to eq("http://example.org/chat/#{chat.id}")
      end
    end

    describe "/chat/new" do
      before (:all) do
        fake_friend = fake_user.update({:username => "friendA"})
        @friendA = User.create fake_friend
        fake_friend = fake_user.update({:username => "friendB"})
        @friendB = User.create fake_friend
      end

      before(:each) do
        @user.chats.all.destroy
        p 'chat all destroy'
      end

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

      end

    end

  end

end
