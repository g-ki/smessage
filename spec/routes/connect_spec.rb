require_relative '../spec_helper'

describe "User connections" do
  context "when logged out" do

    before(:all) { get '/logout' }

    it "should be restricted from connect '/connect/*'" do
      get '/connect'
      expect(last_response.redirection?).to be true
      expect(last_response.location).to eq("http://example.org/login")
    end

  end

  context "when logged in" do

    before(:each) do
      User.all.each { |user| user.destroy }
      @user = User.create fake_user
      fake_friend = fake_user.update({:username => "friend"})
      @friend = User.create fake_friend
      post "/login", fake_user
    end

    it "should see all friends" do
      get '/connect'
      @user.friends.each do |friend|
        expect(last_response.body).to include friend.username
      end
    end

    it "should see all requests" do
      get '/connect'
      User.all(:contacts => [@user]).each do |friend|
        expect(last_response.body).to include friend.username
      end
    end

    it "should be able to connect" do
      get "/connect/{#{@friend.id}}"
      @user.reload

      expect(@user.contacts).to include @friend
    end

    it "should find other users" do
      @user.connections.all.destroy
      post "/connect/find", {search: @friend.username}

      expect(last_response.body).to include @friend.username
    end

  end
end
