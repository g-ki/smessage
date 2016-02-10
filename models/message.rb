class Message
  include DataMapper::Resource

  property :id, Serial

  property :content, Text, :required => true

  belongs_to :user
  belongs_to :chat
  
end
