require_relative '../spec_helper'

describe "Message model" do

  before :each do
    User.all.destroy
    Chat.all.destroy
    Message.all.destroy
    @user = User.create fake_user
  end

  def make_chat_with_message
    chat = @user.chats.create
    chat.users << User.create(rand_user)
    chat.update
    msg = @user.messages.create(:content => "This is MSG!",:chat => chat)
    [chat, msg]
  end

  it "create new" do
    chat, msg = make_chat_with_message

    expect(msg.saved?).to be true
    expect(msg.user).to be @user
    expect(msg.chat).to be chat
  end

  it "destroy" do
    chat, msg = make_chat_with_message

    id = msg.id
    msg.destroy

    expect(Message.get(id)).to be nil
    expect(User.get(@user.id)).to be
    expect(User.get(@user.id).messages.count).to be 0
    expect(Chat.get(chat.id)).to be
    expect(Chat.get(chat.id).messages.count).to be 0
  end
end
