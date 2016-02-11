require_relative '../spec_helper'

describe "User model" do

  before :each do
    User.all.destroy
    @user = User.create fake_user
  end

  def make_friend
    contact = User.create rand_user
    @user.send_request contact
    contact.send_request @user
    contact
  end

  it "should authenticate" do
    user = User.authenticate(@user.username, fake_user[:password])

    expect(@user).to eq(user)
  end

  describe "friends" do
    it "new instace should have no friends and contacts" do
      expect(@user.friends.size).to eq(0)
      expect(@user.contacts.size).to eq(0)
    end

    it "should be able to send friend requsts" do
      contact = User.create rand_user

      @user.send_request contact

      @user.contacts.include?(contact)
    end


    it "make" do
      contact = make_friend

      expect(@user.friends.all.count).to eq(1)
      expect(@user.friends).to include(contact)
    end

    it "delete" do
      contact = make_friend

      @user.connections.first(:target => contact).destroy
      contact.connections.first(:target => @user).destroy

      expect(@user.friends.all.count).to eq(0)
      expect(contact.friends.all.count).to eq(0)
    end
  end

  describe "destroy" do
    it "empty user" do
      @user.destroy
      expect(User.all.count).to eq(0)
    end

    it "user with friends" do
      make_friend
      make_friend
      @user.destroy
      expect(User.all.count).to eq(2)
    end

    it "user with messages" do
      Message.all.destroy
      @user.messages.create(:content => "This is message!!!")
      @user.destroy
      expect(User.all.count).to eq(0)
      expect(Message.all.count).to eq(0)
    end

    it "user with chats" do
      chat = @user.chats.create

      id = @user.id
      @user.destroy

      expect(User.get(id)).to be nil
      expect(Chat.get(chat.id)).to be
    end

    it "user with chats and messages" do
      chat = @user.chats.create
      other_user = User.create(rand_user)
      chat.users << other_user
      chat.update
      msg = Message.create(:content => "MSG", :user => @user, :chat => chat)

      id = @user.id
      @user.destroy

      expect(User.get(id)).to be nil
      expect(User.get(other_user.id)).to be
      expect(Chat.get(chat.id)).to be
      expect(Chat.get(chat.id).users.count).to be 1
      expect(Chat.get(chat.id).users.get(other_user.id)).to be
      expect(Message.get(msg.id)).to be nil
    end
  end

end
