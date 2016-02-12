class Message
  include DataMapper::Resource

  class View
    include DataMapper::Resource

    belongs_to :message, 'Message', :key => true
    belongs_to :user, 'User', :key => true
  end

  property :id, Serial

  property :content, Text, :required => true

  property :expire_at, DateTime

  belongs_to :user
  belongs_to :chat

  has n, :message_views, 'Message::View', :child_key => [:message_id], :constraint => :destroy
  has n, :viewers, 'User', :through => :message_views, :via => :user, :constraint => :skip

  #default_scope.update(:conditions => {:expire_at.gt => DateTime.now})
  def self.all_valid
    all(:expire_at.gt => DateTime.now) | all(:expire_at => nil)
  end
end
