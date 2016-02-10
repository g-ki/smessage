class User
  include DataMapper::Resource

  property :id, Serial

  property :username, String, :required => true, :unique => true
  property :password, BCryptHash, :required => true

  has n, :connections, :child_key => [:source_id]
  has n, :contacts, self, :through => :connections, :via => :target

  has n, :chats, :through => Resource
  has n, :messages

  def self.authenticate(username, password)
    user = User.first username: username

    return nil if user.nil?

    return user if  user.password == password

    nil
  end

  def conntected?(other)
    not contacts.get(other.id).nil?
  end

  def friend?(other)
    conntected?(other) and other.conntected?(self)
  end

  def friends
    contacts & User.all(:connections => [:target => self])
  end

  def send_request(other)
    contacts << other unless conntected? other
    save
    self
  end

end

class Connection
  include DataMapper::Resource

  belongs_to :source, 'User', :key => true
  belongs_to :target, 'User', :key => true
end
