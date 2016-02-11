class Chat
  include DataMapper::Resource

  property :id, Serial

  property :name, String
  property :updated_at, DateTime


  has n, :users, :through => Resource, :constraint => :skip
  has n, :messages, :constraint => :destroy


  def name(current_user = nil)
    return @name if @name || current_user.nil?
    (users - current_user).map(&:username).join(", ")
  end

end
