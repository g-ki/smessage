class User
  include DataMapper::Resource

  property :id, Serial

  property :username, String, :required => true, :unique => true
  property :password, BCryptHash, :required => true

  has n, :friendships, :child_key => [:source_id]
  has n, :friends, self, :through => :friendships, :via => :target


  def self.authenticate(username, password)
    user = User.first username: username

    return nil if user.nil?

    return user if  user.password == password

    nil
  end

  def conntected?(other)
    friends.get other.id
  end

  def friend?(other)
    conntected?(other) and other.conntected?(self)
  end

  def send_request(other)
    friends << other unless conntected? other
    save
    self
  end

end

class Friendship
  include DataMapper::Resource

  belongs_to :source, 'User', :key => true
  belongs_to :target, 'User', :key => true
end
