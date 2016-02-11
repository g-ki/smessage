require_relative '../spec_helper'

describe "Message model" do

  def make_chat_with_message
    chat = @user.chats.create
    chat.users << User.create(rand_user)
    chat.update
    msg = @user.messages.create(:content => "This is CHAT_MSG!",:chat => chat)
    [chat, msg]
  end

  before :each do
    User.all.destroy
    Chat.all.destroy
    Message.all.destroy
    @user = User.create fake_user
    @chat, @msg = make_chat_with_message
  end

  it "create new" do
    expect(@msg.saved?).to be true
    expect(@msg.user).to be @user
    expect(@msg.chat).to be @chat
  end

  it "destroy" do
    id = @msg.id
    @msg.destroy

    expect(Message.get(id)).to be nil
    expect(User.get(@user.id)).to be
    expect(User.get(@user.id).messages.count).to be 0
    expect(Chat.get(@chat.id)).to be
    expect(Chat.get(@chat.id).messages.count).to be 0
  end

  it "view" do
    @msg.viewers << @user
    @msg.save

    expect(@msg.viewers.get(@user.id)).to be
  end

  it "destroy all views" do
    @msg.viewers << @user << (@chat.users - [@user]).first
    @msg.save

    expect(@msg.viewers.get(@user.id)).to be
  end

  describe "expire_at" do

    it "should be unvalid if expire" do
      @msg.expire_at = DateTime.now.to_date.prev_day.to_datetime
      @msg.save

      expect(Message.all_valid).not_to include(@msg)

      @msg.expire_at = DateTime.now.to_date.next.to_datetime
      @msg.save
      
      expect(Message.all_valid).to include(@msg)
    end

  end
end
