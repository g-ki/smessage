class User
  include DataMapper::Resource

  property :id, Serial

  property :username, String, :required => true, :unique => true
  property :password, BCryptHash, :required => true


  def self.authenticate(username, password)
    user = User.first username: username

    return nil if user.nil?

    return user if  user.password == password

    nil
  end

end
