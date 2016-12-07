require_relative 'user'
require_relative 'chat'
require_relative 'message'

DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/smessage.db")
DataMapper.finalize.auto_upgrade!


# Create a test User
if User.count == 0
  user = User.create(username: "test")
  user.password = "test"
  user.save
end
