require_relative '../spec_helper'

describe "User" do

  context "when logged out" do
    it "should be allowed to Landing Page '/'" do
      get '/'
      expect(last_response).to be_ok
    end

    it "on Landing Page should hava Sign In and Sign Up forms" do
      get '/'

      expect(last_response.body).to include "<legend>Sign In</legend>"

      expect(last_response.body).to include "<legend>Sign Up</legend>"
    end

    it "shoude be allowed to Login '/login' and  Signup '/Signup'" do
      get '/login'
      expect(last_response.body).to include "<legend>Sign In</legend>"

      get '/signup'
      expect(last_response.body).to include "<legend>Sign Up</legend>"
    end

    it "shoude be restricted from chat '/chat/*'" do
      get '/chat'
      expect(last_response.redirection?).to be true
      expect(last_response.location).to eq("http://example.org/login")

      get '/chat/*'
      expect(last_response.redirection?).to be true
      expect(last_response.location).to eq("http://example.org/login")
    end

  end

  context "when registers" do

    before :each do
      User.all.each { |user| user.destroy }
    end

    it "should be able" do
      post '/signup', fake_user.merge({:password2 => fake_user[:password]})
      expect(User.first(:username => fake_user[:username])).to be
    end

    it "should not be allowed users with same username" do
      User.create fake_user
      post '/signup', fake_user.merge({:password2 => fake_user[:password]})

      expect(User.count(:username => fake_user[:username])).to be 1

      expect(last_response.redirection?).to be true
      expect(last_response.location).to eq("http://example.org/signup")
    end

  end

  context "when logged in" do

    before(:all) do
      User.all.each { |user| user.destroy }
      User.create fake_user
      post "/login", fake_user
    end

    let(:user) { User.first(:username => "user") }

    it "should be redirec form '/' to '/chat'" do
      get '/'
      expect(last_response.redirection?).to be true
      expect(last_response.location).to eq("http://example.org/chat")
    end

  end

end
