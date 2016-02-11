require_relative '../spec_helper'

describe "Chat model" do

  before :each do
    User.all.destroy
    Chat.all.destroy
    Message.all.destroy
    @user = User.create fake_user
  end

  it "new" do
    chat = Chat.new
    chat.users << @user << User.create(rand_user) << User.create(rand_user)
    chat.save

    expect(chat.saved?).to be true
  end

  it "destroy" do
    chat = Chat.create
    chat.users << @user << User.create(rand_user) << User.create(rand_user)
    chat.update

    id = chat.id
    users = chat.users.all
    chat.destroy

    expect(Chat.get(id)).to be nil
    expect(User.all.count).to eq(3)
    users.each do |user|
      expect(User.get(user.id)).to be
    end
  end

  it "add messages" do
    chat = Chat.create
    chat.messages.create(:content => "This is MSG!", :user => @user)

    expect(chat.messages.all.count).to be 1
    expect(@user.messages.all.count).to be 1
  end

  it "destroy message" do
    chat = Chat.create
    msg = chat.messages.create(:content => "This is MSG!", :user => @user)
    id = msg.id
    chat.messages.get(id).destroy

    expect(Message.get(id)).to be nil
    expect(chat.messages.all.count).to be 0
    expect(@user.messages.all.count).to be 0
  end

  describe "group chat" do

    it "is group with more then 2 members" do
      chat = Chat.create
      chat.users << @user << User.create(rand_user) << User.create(rand_user)
      chat.update

      expect(chat.group?).to be true
    end

    it "is not group with less then 3 members" do
      chat = Chat.create
      chat.users << @user << User.create(rand_user)
      chat.update

      expect(chat.group?).to be false
    end
  end

end
