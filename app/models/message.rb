class Message < ActiveRecord::Base
	validates :body, presence: true
	enum status: [:unread, :read] 
  belongs_to :recipient, class_name: 'User'
  belongs_to :sender, class_name: 'User'
  belongs_to :conversation

  default_scope { order('created_at ASC') }

  # sync :all
  # sync_scope :by_conversation, ->(conversation) { where(conversation_id: conversation.id) }
end
